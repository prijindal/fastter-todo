import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:uuid/uuid.dart';
import 'package:watch_it/watch_it.dart';

import '../helpers/logger.dart';
import '../models/core.dart';
import 'backend/entity_types.dart';
import 'db_crud_operations.dart';

class BackendSyncService {
  final io.Socket _socket;

  SharedDatabase get _database => GetIt.I<SharedDatabase>();
  DbCrudOperations get dbCrudOperations => GetIt.I<DbCrudOperations>();
  Timer? _timer;

  bool _performingActions = false;

  late final managers = [
    dbCrudOperations.todo,
    dbCrudOperations.project,
    dbCrudOperations.comment,
    dbCrudOperations.reminder,
  ];

  Iterable<String> get entities {
    return managers.map((a) => a.entityName);
  }

  TableCrudOperation<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic,
      dynamic, dynamic, dynamic, dynamic> getManager(String entityName) {
    final operation = managers.singleWhere((a) => a.entityName == entityName);
    return operation;
  }

  BackendSyncService({required io.Socket socket}) : _socket = socket {
    init();
  }

  Future<void> init() async {
    await _sendQueueData();
    _timer =
        Timer.periodic(Duration(milliseconds: 100), (_) => _sendQueueData());
    await _fetchHistoryWrapper();
    // After running _sendQueueData once, create a timer to run it perioidically
    // Fetch data from server, using list operation
  }

  Future<R> _emitWithResponse<T, R>(
      String event, T request, R Function(dynamic data) fromJson) {
    var completer = Completer<R>();
    _socket.emitWithAck(event, jsonEncode(request), ack: (dynamic data) {
      completer.complete(fromJson(data));
    });
    return completer.future;
  }

  void disconnect() {
    _timer?.cancel();
  }

  Future<List<EntityActionResponse>> _emitActions(
      List<EntityActionBase> actions) {
    return _emitWithResponse<List<EntityActionBase>,
            List<EntityActionResponse>>(
        "actions",
        actions,
        (dynamic data) => (data as List<dynamic>)
            .map(
                (a) => EntityActionResponse.fromJson(a as Map<String, dynamic>))
            .toList());
  }

  Future<List<EntityHistoryResponse>> _emitHistory(
      List<EntityHistoryRequest> history) {
    return _emitWithResponse<List<EntityHistoryRequest>,
            List<EntityHistoryResponse>>(
        "search_history",
        history,
        (dynamic data) => (data as List<dynamic>)
            .map((a) =>
                EntityHistoryResponse.fromJson(a as Map<String, dynamic>))
            .toList());
  }

  Future<void> _sendQueueData() async {
    if (_performingActions) return;
    _performingActions = true;
    final queue = await _database.managers.entityActionsQueue
        .orderBy((o) => o.timestamp.asc())
        .get();
    if (queue.isEmpty) return;
    AppLogger.instance.i("Sending actions to server ${queue.length}");
    final hostId = await getHostId();
    final List<EntityActionBase> actions = queue.map<EntityActionBase>((a) {
      if (a.action == "CREATE") {
        return EntityActionCreate(
          entityName: a.name,
          payload: a.payload,
          entityId: a.id,
          hostId: hostId,
          requestId: a.requestId,
          timestamp: a.timestamp,
        );
      } else if (a.action == "UPDATE") {
        return EntityActionUpdate(
          entityName: a.name,
          payload: a.payload,
          entityId: a.id,
          requestId: a.requestId,
          hostId: hostId,
          timestamp: a.timestamp,
        );
      } else if (a.action == "DELETE") {
        return EntityActionDelete(
          entityName: a.name,
          entityId: a.id,
          requestId: a.requestId,
          hostId: hostId,
          timestamp: a.timestamp,
        );
      }
      throw Error();
    }).toList();
    final data = await _emitActions(actions);
    AppLogger.instance.i(data.map((a) => a.toJson()).toList());
    await _database.managers.entityActionsQueue
        .filter((f) => f.requestId.isIn(queue.map((a) => a.requestId).toList()))
        .delete();
    _performingActions = false;
  }

  Future<String> getHostId() async {
    final existingHostId = await SharedPreferencesAsync().getString("hostId");
    if (existingHostId != null) {
      return existingHostId;
    }
    final hostId = Uuid().v4();
    await SharedPreferencesAsync().setString("hostId", hostId);
    return hostId;
  }

  Future<void> _fetchHistoryWrapper() async {
    final hostId = await getHostId();
    final lastUpdatedAt =
        await SharedPreferencesAsync().getInt("lastUpdatedAt");
    await _fetchHistory(
      lastUpdatedAt: lastUpdatedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(lastUpdatedAt),
      hostId: hostId,
    );
    await SharedPreferencesAsync()
        .setInt("lastUpdatedAt", DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> consumeServerHistory(
      Iterable<EntityHistoryResponse> history) async {
    await _consumeHistory(history);
    await SharedPreferencesAsync()
        .setInt("lastUpdatedAt", DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _consumeHistory(Iterable<EntityHistoryResponse> history) async {
    for (var histor in history) {
      final manager = getManager(histor.entityName);
      AppLogger.instance
          .i("Fetched ${histor.data.length} entries for ${histor.entityName}");
      for (var row in histor.data) {
        if (row.action == "CREATE") {
          final payload = manager.insertable(row.payload);
          await _database
              .into(manager.table as drift.TableInfo<drift.Table, dynamic>)
              .insert(
                payload,
                onConflict: drift.DoNothing(),
              );
        } else if (row.action == "UPDATE") {
          final existingEntry = await manager.manager
              .filter((f) => (f.id as dynamic).equals(row.entityId)
                  as drift.Expression<bool>)
              .getSingle() as drift.DataClass?;
          if (existingEntry != null) {
            final existing = existingEntry.toJson();
            existing.addAll(row.payload);
            final payload = manager.insertable(existing);
            (_database.update(
              manager.table as drift.TableInfo<drift.Table, dynamic>,
            )..where((u) => (u as dynamic).id.equals(row.entityId)
                    as drift.Expression<bool>))
                .write(payload);
          }
        } else if (row.action == "DELETE") {
          await (_database.delete(
                  manager.table as drift.TableInfo<drift.Table, dynamic>)
                ..where((u) => (u as dynamic).id.equals(row.entityId)
                    as drift.Expression<bool>))
              .go();
        }
      }
    }
  }

  Future<void> _fetchHistory({
    DateTime? lastUpdatedAt,
    required String hostId,
  }) async {
    AppLogger.instance.i("Fetching history");
    EntityHistoryParams params = EntityHistoryParams(
      hostId: HostParams(ne: hostId),
    );
    if (lastUpdatedAt != null) {
      params = EntityHistoryParams(
        createdAt: DateParams(gte: lastUpdatedAt),
        hostId: HostParams(ne: hostId),
      );
    }
    final historyRequest = entities.map(
      (entityName) => EntityHistoryRequest(
        entityName: entityName,
        params: params,
        order: {
          "timestamp": "asc",
        },
      ),
    );
    final history = await _emitHistory(historyRequest.toList());
    await _consumeHistory(history);
  }
}

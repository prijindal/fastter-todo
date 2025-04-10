import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:watch_it/watch_it.dart';

import '../grpc_client/api_from_server.dart';
import '../helpers/logger.dart';
import '../models/core.dart';
import '../schemaless_proto/google/protobuf/timestamp.pb.dart';
import '../schemaless_proto/types/entity.pb.dart';
import 'db_crud_operations.dart';

class BackendSyncService {
  final ApiFromServerInfo _server;
  StreamSubscription<EntityHistory>? _subscription;
  bool get isConnected => _subscription != null;

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
    return managers.map((a) => a.table.entityName);
  }

  TableCrudOperation<dynamic, dynamic> getManager(String entityName) {
    final operation =
        managers.singleWhere((a) => a.table.entityName == entityName);
    return operation;
  }

  BackendSyncService({required ApiFromServerInfo server}) : _server = server {
    init();
  }

  Future<void> init() async {
    await _sendQueueData();
    _timer =
        Timer.periodic(Duration(milliseconds: 100), (_) => _sendQueueData());
    // After running _sendQueueData once, create a timer to run it perioidically
  }

  void disconnect() {
    _timer?.cancel();
    _subscription?.cancel();
  }

  Future<void> _sendQueueData() async {
    if (_performingActions) return;
    _performingActions = true;
    final queue = await _database.managers.entityActionsQueue
        .orderBy((o) => o.timestamp.asc())
        .get();
    if (queue.isEmpty) {
      _performingActions = false;
      return;
    }
    AppLogger.instance.i("Sending actions to server ${queue.length}");
    final hostId = await getHostId();
    final List<EntityActionRequest> actions =
        queue.map<EntityActionRequest>((a) {
      if (a.action == "CREATE") {
        return EntityActionRequest(
          hostID: hostId,
          actionId: Uuid().v4(),
          entityName: a.name,
          action: EntityAction.CREATE,
          createdAt: Timestamp.fromDateTime(a.timestamp),
          entityId: a.id,
          payload: jsonEncode(a.payload).codeUnits,
          requestID: a.requestId,
        );
      } else if (a.action == "UPDATE") {
        return EntityActionRequest(
          hostID: hostId,
          actionId: Uuid().v4(),
          entityName: a.name,
          action: EntityAction.UPDATE,
          createdAt: Timestamp.fromDateTime(a.timestamp),
          entityId: a.id,
          payload: jsonEncode(a.payload).codeUnits,
          requestID: a.requestId,
        );
      } else if (a.action == "DELETE") {
        return EntityActionRequest(
          hostID: hostId,
          actionId: Uuid().v4(),
          entityName: a.name,
          action: EntityAction.DELETE,
          createdAt: Timestamp.fromDateTime(a.timestamp),
          entityId: a.id,
          requestID: a.requestId,
        );
      }
      throw Error();
    }).toList();
    for (var action in actions) {
      await _server.entityClient.entityAction(action);
    }
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

  Future<DateTime?> getLastUpdatedAt() async {
    final lastUpdatedAt =
        await SharedPreferencesAsync().getInt("lastUpdatedAt");
    return lastUpdatedAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(lastUpdatedAt);
  }

  Future<void> listenOnEntityHistory() async {
    final hostId = await getHostId();
    final lastUpdatedAt = await getLastUpdatedAt();
    final stream = _server.entityClient.searchEntityHistory(
      SearchEntityHistoryRequest(
        params: EntityHistoryRequestParams(
          createdAt: EntityHistoryRequestDateParam(
            gte: lastUpdatedAt == null
                ? null
                : Timestamp.fromDateTime(lastUpdatedAt),
          ),
          hostID: EntityHistoryRequestHostIDParam(
            neq: hostId,
          ),
        ),
        order: [
          EntityHistoryRequestOrder(
            field_1: EntityHistoryOrderField.CreatedAt,
            value: EntityHistoryOrderValue.DESC,
          )
        ],
      ),
    );
    _subscription = stream.listen((d) => _consumeHistory(d));
    AppLogger.instance.i("Started listening on stream");
  }

  Future<void> _consumeHistory(EntityHistory history) async {
    final manager = getManager(history.entityName);
    AppLogger.instance
        .i("Fetched ${history.entityID} entry for ${history.entityName}");
    if (history.action == EntityAction.CREATE) {
      final payload = manager.insertable(
        jsonDecode(String.fromCharCodes(history.payload))
            as Map<String, dynamic>,
      );
      await _database
          .into(manager.table as drift.TableInfo<drift.Table, dynamic>)
          .insert(
            payload,
            onConflict: drift.DoNothing(),
          );
    } else if (history.action == EntityAction.UPDATE) {
      final existingEntry =
          (await manager.getById(history.entityID)) as drift.DataClass?;
      if (existingEntry != null) {
        final existing = existingEntry.toJson();
        existing.addAll(
          jsonDecode(String.fromCharCodes(history.payload))
              as Map<String, dynamic>,
        );
        final payload = manager.insertable(existing);
        (_database.update(
          manager.table as drift.TableInfo<drift.Table, dynamic>,
        )..where((u) => (u as dynamic).id.equals(history.entityID)
                as drift.Expression<bool>))
            .write(payload);
      }
    } else if (history.action == EntityAction.DELETE) {
      await (_database
              .delete(manager.table as drift.TableInfo<drift.Table, dynamic>)
            ..where((u) => (u as dynamic).id.equals(history.entityID)
                as drift.Expression<bool>))
          .go();
    }
    await SharedPreferencesAsync().setInt(
        "lastUpdatedAt", history.createdAt.toDateTime().millisecondsSinceEpoch);
  }
}

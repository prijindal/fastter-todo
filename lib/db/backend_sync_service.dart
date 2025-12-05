import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:watch_it/watch_it.dart';

import '../grpc_client/api_from_server.dart';
import '../helpers/logger.dart';
import '../models/core.dart';
import '../schemaless_proto/application_services/v1/entity.pb.dart';
import '../schemaless_proto/google/protobuf/timestamp.pb.dart';
import 'db_crud_operations.dart';

class BackendSyncService {
  final ApiFromServerInfo _server;
  StreamSubscription<StreamEntityHistoryResponse>? _subscription;
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
          entityName: a.name,
          action: EntityAction.ENTITY_ACTION_CREATE,
          timestamp: Timestamp.fromDateTime(a.timestamp),
          entityId: a.id,
          payload: jsonEncode(a.payload).codeUnits,
          requestId: a.requestId,
        );
      } else if (a.action == "UPDATE") {
        return EntityActionRequest(
          entityName: a.name,
          action: EntityAction.ENTITY_ACTION_UPDATE,
          timestamp: Timestamp.fromDateTime(a.timestamp),
          entityId: a.id,
          payload: jsonEncode(a.payload).codeUnits,
          requestId: a.requestId,
        );
      } else if (a.action == "DELETE") {
        return EntityActionRequest(
          entityName: a.name,
          action: EntityAction.ENTITY_ACTION_DELETE,
          timestamp: Timestamp.fromDateTime(a.timestamp),
          entityId: a.id,
          requestId: a.requestId,
        );
      }
      throw Error();
    }).toList();
    for (var action in actions) {
      print(action);
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
    final stream = _server.entityClient.streamEntityHistory(
      StreamEntityHistoryRequest(
        entityName: "todo",
        params: [EntityHistoryRequestParam(
          field_1: "created_at",
          dataParams: EntityHistoryRequestDateParam(
            gte: lastUpdatedAt == null
                ? null
                : Timestamp.fromDateTime(lastUpdatedAt),
          ),
        ),
        ],
        order: [
          EntityHistoryRequestOrder(
            field_1: "updated_at",
            value: EntityHistoryOrderValue.ENTITY_HISTORY_ORDER_VALUE_DESC,
          )
        ],
      ),
    );
    _subscription = stream.listen((d) => _consumeHistory(d));
    AppLogger.instance.i("Started listening on stream");
  }

  Future<void> _consumeHistory(StreamEntityHistoryResponse resp) async {
    final entity = resp.entity;
    final manager = getManager(entity.entityName);
    AppLogger.instance
        .i("Fetched ${entity.id} entry for ${entity.entityName}");
        
      final existingEntry =
          (await manager.getById(entity.id)) as drift.DataClass?;
      if(entity.deletedAt.hasRequiredFields()) {

      await (_database
              .delete(manager.table as drift.TableInfo<drift.Table, dynamic>)
            ..where((u) => (u as dynamic).id.equals(entity.id)
                as drift.Expression<bool>))
          .go();
      }
      else if (existingEntry != null) {
        final existing = existingEntry.toJson();
        existing.addAll(
          jsonDecode(String.fromCharCodes(entity.payload))
              as Map<String, dynamic>,
        );
        final payload = manager.insertable(existing);
        (_database.update(
          manager.table as drift.TableInfo<drift.Table, dynamic>,
        )..where((u) => (u as dynamic).id.equals(entity.id)
                as drift.Expression<bool>))
            .write(payload);
      } else {
      final payload = manager.insertable(
        jsonDecode(String.fromCharCodes(entity.payload))
              as Map<String, dynamic>,
      );
      await _database
          .into(manager.table as drift.TableInfo<drift.Table, dynamic>)
          .insert(
            payload,
            onConflict: drift.DoNothing(),
          );
      }

    await SharedPreferencesAsync().setInt(
        "lastUpdatedAt", entity.createdAt.toDateTime().millisecondsSinceEpoch);
  }
}

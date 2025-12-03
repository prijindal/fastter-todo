import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:watch_it/watch_it.dart';

import '../helpers/logger.dart';
import '../models/core.dart';
import 'backend_connector.dart';
import 'backend_sync_configuration.dart';

enum TableName {
  project,
  todo,
  comment,
  reminder;
}

class DbCrudOperations {
  final _database = GetIt.I<SharedDatabase>();
  final _backendSyncConfig = GetIt.I<BackendSyncConfigurationService>();
  BackendConnector? _backendConneector;

  BackendConnector? get backendConnector => _backendConneector;

  late final project = TableCrudOperation(
    _database.project,
    (json) => ProjectData.fromJson(json).toCompanion(true),
    _database.managers.entityActionsQueue,
  );
  late final todo = TableCrudOperation(
    _database.todo,
    (json) => TodoData.fromJson(json).toCompanion(true),
    _database.managers.entityActionsQueue,
  );
  late final comment = TableCrudOperation(
    _database.comment,
    (json) => CommentData.fromJson(json).toCompanion(true),
    _database.managers.entityActionsQueue,
  );
  late final reminder = TableCrudOperation(
    _database.reminder,
    (json) => ReminderData.fromJson(json).toCompanion(true),
    _database.managers.entityActionsQueue,
  );

  DbCrudOperations() {
    if (_backendSyncConfig.backendSyncConfiguration != null) {
      BackendConnector.init(_backendSyncConfig.backendSyncConfiguration!)
          .then((value) {
        _backendConneector = value;
      });
    }
  }

  // This will drop all the tables in the database and recreate it
  Future<void> resetDatabase() async {
    await _database.customStatement("DROP TABLE reminder;");
    await _database.customStatement("DROP TABLE comment;");
    await _database.customStatement("DROP TABLE todo;");
    await _database.customStatement("DROP TABLE project;");
    await _database.customStatement("PRAGMA user_version = 0;");
  }

  Future<void> deleteParentTodosByParentIds(List<String> parentIds) async {
    final childTodos = await _database.managers.todo
        .filter((f) => f.parent.isIn(parentIds))
        .get();
    for (var childTodo in childTodos) {
      AppLogger.instance.i("Deleting Child todo: ${childTodo.id}");
      await deleteTodosByIds([childTodo.id]);
    }
  }

  // These are helper methods for db deletion/updation etc
  Future<void> deleteTodosByIds(List<String> ids) async {
    AppLogger.instance.i("Deleting todos: ${ids.join(",")}");
    final comments =
        await _database.managers.comment.filter((f) => f.todo.isIn(ids)).get();
    final reminders =
        await _database.managers.reminder.filter((f) => f.todo.isIn(ids)).get();
    await comment.delete(comments.map((e) => e.id));
    await reminder.delete(reminders.map((e) => e.id));
    await todo.delete(ids);
    await deleteParentTodosByParentIds(ids);
  }
}

class TableCrudOperation<$Table extends drift.Table,
    $Dataclass extends drift.DataClass> {
  final database = GetIt.I<SharedDatabase>();

  final $$EntityActionsQueueTableTableManager queueTableManager;
  final drift.TableInfo<$Table, $Dataclass> table;
  drift.Insertable<$Dataclass> Function(Map<String, dynamic>) insertable;

  TableCrudOperation(
    this.table,
    this.insertable,
    this.queueTableManager,
  );

  drift.Expression<bool> _idsFilter(Iterable<String> ids) {
    return (table as dynamic).id.isIn(ids) as drift.Expression<bool>;
  }

  Future<void> _createInQueue($Dataclass created) async {
    await queueTableManager.create(
          (o) => o(
            id: (created as dynamic).id as String,
            name: table.entityName,
            action: "CREATE",
            payload: created.toJson(),
            timestamp: DateTime.now(),
          ),
        );
  }

  Future<void> _updateInQueue(
      List<$Dataclass> previous, List<String> ids) async {
    final afterUpdate =
        await (table.select()..where((f) => _idsFilter(ids))).get();
    for (var element in afterUpdate) {
      final elementJson = element.toJson();
      final previousJson = previous
          .firstWhere((prev) => (prev as dynamic).id == (element as dynamic).id)
          .toJson();
      final updateJson = <String, dynamic>{};
      for (var key in elementJson.keys) {
        if (elementJson[key] != previousJson[key]) {
          updateJson[key] = elementJson[key];
        }
      }
      await queueTableManager.create(
            (o) => o(
              id: (element as dynamic).id as String,
              name: table.entityName,
              action: "UPDATE",
              payload: updateJson,
              timestamp: DateTime.now(),
            ),
          );
    }
  }

  Future<void> _deleteInQueue(List<String> ids) async {
    for (var id in ids) {
      await queueTableManager.create(
            (o) => o(
              id: id,
              name: table.entityName,
              action: "DELETE",
              payload: {},
              timestamp: DateTime.now(),
            ),
          );
    }
  }

  Future<$Dataclass> create(drift.Insertable<$Dataclass> f) async {
    final created = await (table.insertReturning(f));
    unawaited(_createInQueue(created));
    return created;
  }

  Future<void> insert(List<dynamic> entries) async {
    await database.batch((batch) {
      batch.insertAll(
        table,
        entries.map((a) => insertable(a as Map<String, dynamic>)),
        mode: drift.InsertMode.insertOrIgnore,
      );
    });
    final insertedEntries = await (table.select()
          ..where((f) =>
              (f as dynamic).id.isIn(entries.map((e) => e["id"] as String))
                  as drift.Expression<bool>))
        .get();
    for (var entry in insertedEntries) {
      await _createInQueue(entry);
    }
  }

  Future<int> update(
    Iterable<String> ids,
    drift.Insertable<$Dataclass> f,
  ) async {
    final previous =
        await (table.select()..where((f) => _idsFilter(ids))).get();
    final updated =
        await (table.update()..where((f) => _idsFilter(ids))).write(f);
    unawaited(_updateInQueue(previous, ids.toList()));
    return updated;
  }

  Future<void> delete(Iterable<String> ids) async {
    await (table.delete()..where((f) => _idsFilter(ids))).go();
    unawaited(_deleteInQueue(ids.toList()));
  }

  Future<List<$Dataclass>> get() async {
    return await table.select().get();
  }

  Future<$Dataclass?> getById(String id) async {
    return await (table.select()
          ..where(
              (f) => (f as dynamic).id.equals(id) as drift.Expression<bool>))
        .getSingleOrNull();
  }
}

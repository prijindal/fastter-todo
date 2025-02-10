import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:watch_it/watch_it.dart';

import '../helpers/logger.dart';
import '../models/core.dart';
import 'backend_connector.dart';
import 'backend_sync.dart';

enum TableName {
  project,
  todo,
  comment,
  reminder;
}

class DbCrudOperations {
  final _database = GetIt.I<SharedDatabase>();
  final _backendSync = GetIt.I<BackendSync>();
  late final project = _TableCrudOperation(
    _database.project.entityName,
    _database.managers.project,
    _database.managers.entityActionsQueue,
  );
  late final todo = _TableCrudOperation(
    _database.todo.entityName,
    _database.managers.todo,
    _database.managers.entityActionsQueue,
  );
  late final comment = _TableCrudOperation(
    _database.comment.entityName,
    _database.managers.comment,
    _database.managers.entityActionsQueue,
  );
  late final reminder = _TableCrudOperation(
    _database.reminder.entityName,
    _database.managers.reminder,
    _database.managers.entityActionsQueue,
  );

  DbCrudOperations() {
    if (_backendSync.backendSyncConfiguration != null) {
      BackendConnector.init(_backendSync.backendSyncConfiguration!);
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
    await Future.wait([
      _database.managers.comment.filter((f) => f.todo.isIn(ids)).delete(),
      _database.managers.reminder.filter((f) => f.todo.isIn(ids)).delete(),
      _database.managers.todo.filter((f) => f.id.isIn(ids)).delete(),
      deleteParentTodosByParentIds(ids),
    ]);
  }
}

class _TableCrudOperation<
    $Database extends drift.GeneratedDatabase,
    $Table extends drift.Table,
    $Dataclass extends drift.DataClass,
    $FilterComposer extends drift.Composer<$Database, $Table>,
    $OrderingComposer extends drift.Composer<$Database, $Table>,
    $ComputedFieldComposer extends drift.Composer<$Database, $Table>,
    $CreateCompanionCallback extends Function,
    $UpdateCompanionCallback extends Function,
    $DataclassWithReferences,
    $CreatePrefetchHooksCallback extends Function> {
  final drift.RootTableManager<
      $Database,
      $Table,
      $Dataclass,
      $FilterComposer,
      $OrderingComposer,
      $ComputedFieldComposer,
      $CreateCompanionCallback,
      $UpdateCompanionCallback,
      $DataclassWithReferences,
      $Dataclass,
      $CreatePrefetchHooksCallback> manager;

  final $$EntityActionsQueueTableTableManager queueTableManager;
  final String entityName;

  _TableCrudOperation(
    this.entityName,
    this.manager,
    this.queueTableManager,
  );

  drift.Expression<bool> _idsFilter($FilterComposer f, Iterable<String> ids) {
    return (f as dynamic).id.isIn(ids) as drift.Expression<bool>;
  }

  Future<void> _createInQueue($Dataclass created) async {
    await this.queueTableManager.create(
          (o) => o(
            ids: drift.Value([(created as dynamic).id as String]),
            name: entityName,
            action: "CREATE",
            payload: created.toJson(),
            timestamp: DateTime.now(),
          ),
        );
  }

  Future<void> _updateInQueue(
      List<$Dataclass> previous, List<String> ids) async {
    final afterUpdate = await manager.filter((f) => _idsFilter(f, ids)).get();
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
      await this.queueTableManager.create(
            (o) => o(
              ids: drift.Value(ids),
              name: entityName,
              action: "UPDATE",
              payload: updateJson,
              timestamp: DateTime.now(),
            ),
          );
    }
  }

  Future<void> _deleteInQueue(List<String> ids) async {
    await this.queueTableManager.create(
          (o) => o(
            ids: drift.Value(ids.toList()),
            name: entityName,
            action: "DELETE",
            payload: {},
            timestamp: DateTime.now(),
          ),
        );
  }

  Future<$Dataclass> create(
      drift.Insertable<$Dataclass> Function($CreateCompanionCallback) f) async {
    final created = await manager.createReturning(f);
    unawaited(_createInQueue(created));
    return created;
  }

  Future<int> update(
    Iterable<String> ids,
    drift.Insertable<$Dataclass> Function($UpdateCompanionCallback) f,
  ) async {
    final previous = await manager.filter((f) => _idsFilter(f, ids)).get();
    final updated = await manager.filter((f) => _idsFilter(f, ids)).update(f);
    unawaited(_updateInQueue(previous, ids.toList()));
    return updated;
  }

  Future<void> delete(Iterable<String> ids) async {
    await manager.filter((f) => _idsFilter(f, ids)).delete();
    unawaited(_deleteInQueue(ids.toList()));
  }

  Future<List<$Dataclass>> get() async {
    return await manager.get();
  }
}

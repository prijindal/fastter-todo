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
  late final project = _TableCrudOperation(_database.managers.project);
  late final todo = _TableCrudOperation(_database.managers.todo);
  late final comment = _TableCrudOperation(_database.managers.comment);
  late final reminder = _TableCrudOperation(_database.managers.reminder);

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

  _TableCrudOperation(this.manager);

  drift.Expression<bool> _idsFilter($FilterComposer f, Iterable<String> ids) {
    return (f as dynamic).id.isIn(ids) as drift.Expression<bool>;
  }

  Future<int> create(
      drift.Insertable<$Dataclass> Function($CreateCompanionCallback) f) async {
    return await manager.create(f);
  }

  Future<int> update(
    Iterable<String> ids,
    drift.Insertable<$Dataclass> Function($UpdateCompanionCallback) f,
  ) async {
    return await manager.filter((f) => _idsFilter(f, ids)).update(f);
  }

  Future<void> delete(Iterable<String> ids) async {
    await manager.filter((f) => _idsFilter(f, ids)).delete();
  }

  Future<List<$Dataclass>> get() async {
    return await manager.get();
  }
}

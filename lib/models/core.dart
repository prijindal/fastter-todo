import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

import '../helpers/constants.dart';
import 'string_list.dart';

// assuming that your file is called filename.dart. This will give an error at
// first, but it's needed for drift to know about the generated code
part 'core.g.dart';

const _uuid = Uuid();

const defaultPipeline = "todo";

class Project extends Table {
  late final id = text().clientDefault(() => _uuid.v4())();
  late final title = text()();
  late final color = text()();
  late final pipelines = text()
      .map(const StringListConverter())
      .clientDefault(() => jsonEncode([defaultPipeline]))();

  @override
  Set<Column> get primaryKey => {id};
}

class Todo extends Table {
  late final id = text().clientDefault(() => _uuid.v4())();
  late final title = text()();
  late final priority = integer().clientDefault(() => 1)();
  late final pipeline = text().clientDefault(() => defaultPipeline)();
  late final completed = boolean().clientDefault(() => false)();
  late final due_date = dateTime().nullable()();
  late final created_at = dateTime().clientDefault(() => DateTime.now())();
  late final project = text().nullable()();
  late final parent = text().nullable()();
  late final tags = text()
      .map(const StringListConverter())
      .clientDefault(() => jsonEncode([]))();

  @override
  Set<Column> get primaryKey => {id};
}

enum TodoCommentType {
  image,
  text,
  video,
}

class Comment extends Table {
  late final id = text().clientDefault(() => _uuid.v4())();
  late final content = blob()();
  late final type = textEnum<TodoCommentType>()();
  late final todo = text()();
  late final created_at = dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

class Reminder extends Table {
  late final id = text().clientDefault(() => _uuid.v4())();
  late final time = dateTime()();
  late final completed = boolean().clientDefault(() => false)();
  late final todo = text()();

  @override
  Set<Column> get primaryKey => {id};
}

class EntityActionsQueue extends Table {
  late final requestId = text().clientDefault(() => _uuid.v4())();
  late final id = text()(); // entityId
  late final name = text()();
  late final action = text()(); // CREATE, UPDATE, DELETE
  late final payload = text().map(const JsonConverter())();
  late final timestamp = dateTime()();

  @override
  Set<Column> get primaryKey => {requestId};
}

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [Todo, Project, Comment, Reminder, EntityActionsQueue])
class SharedDatabase extends _$SharedDatabase {
  // Keeping a custom constructor is useful for unit tests which may want to
  // open an in-memory database only.
  SharedDatabase(super.e);

  SharedDatabase.local()
      : super(driftDatabase(
          name: dbName,
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.dart.js'),
          ),
        ));

  @override
  int get schemaVersion => 1;
}

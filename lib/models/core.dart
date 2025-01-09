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

class Project extends Table {
  late final id = text().clientDefault(() => _uuid.v4())();
  late final title = text()();
  late final color = text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Todo extends Table {
  late final id = text().clientDefault(() => _uuid.v4())();
  late final title = text()();
  late final priority = integer().clientDefault(() => 1)();
  late final completed = boolean().clientDefault(() => false)();
  late final dueDate = dateTime().nullable()();
  late final creationTime = dateTime().clientDefault(() => DateTime.now())();
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
  late final todo = text().references(
    Todo,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
  late final creationTime = dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

class Reminder extends Table {
  late final id = text().clientDefault(() => _uuid.v4())();
  late final title = text()();
  late final time = dateTime()();
  late final completed = boolean().clientDefault(() => false)();
  late final todo = text().references(
    Todo,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();

  @override
  Set<Column> get primaryKey => {id};
}

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [Todo, Project, Comment, Reminder])
class SharedDatabase extends _$SharedDatabase {
  // Keeping a custom constructor is useful for unit tests which may want to
  // open an in-memory database only.
  SharedDatabase(super.e);

  SharedDatabase.defaults()
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

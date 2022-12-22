import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fastter_todo/models/todocomment.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

// assuming that your file is called filename.dart. This will give an error at
// first, but it's needed for drift to know about the generated code
part 'tables.g.dart';

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
class TodoTable extends Table {
  @override
  String get tableName => 'todos';

  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDate)();

  TextColumn get title => text()();
  IntColumn get priority => integer().withDefault(const Constant(1))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  BoolColumn get encrypted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get dueDate => dateTime().withDefault(currentDate)();

  TextColumn get parent => text().nullable().references(TodoTable, #id)();
  TextColumn get project => text().nullable().references(ProjectTable, #id)();
  // TextColumn get labels => text().nullable().references(LabelTable, #id)();
}

class ProjectTable extends Table {
  @override
  String get tableName => 'projects';

  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDate)();

  TextColumn get title => text()();
  TextColumn get color => text().nullable()();
  IntColumn get index => integer().nullable()();
}

class LabelTable extends Table {
  @override
  String get tableName => 'labels';

  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDate)();

  TextColumn get title => text()();
}

class TodoCommentTable extends Table {
  @override
  String get tableName => 'todocomments';

  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDate)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDate)();

  TextColumn get content => text()();
  IntColumn get type => intEnum<TodoCommentType>()();
  TextColumn get todo => text().nullable().references(TodoTable, #id)();
}

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [
  TodoTable,
  ProjectTable,
  LabelTable,
  TodoCommentTable,
])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());
  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 1;

  static MyDatabase? _instance;

  static MyDatabase get instance {
    _instance ??= MyDatabase();
    return _instance ?? MyDatabase();
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

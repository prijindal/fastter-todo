import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';

import '../db/db_crud_operations.dart';
import '../models/core.dart';
import 'logger.dart';

class DatabaseIO {
  final SharedDatabase database = GetIt.I<SharedDatabase>();
  final DbCrudOperations dbCrudOperations = GetIt.I<DbCrudOperations>();

  Future<String> extractDbJson() async {
    final entries = await database
        .computeWithDatabase<List<List<DataClass>>, SharedDatabase>(
      computation: (database) async {
        final [todo, project, comment, reminder] = await Future.wait([
          database.managers.todo.get(),
          database.managers.project.get(),
          database.managers.comment.get(),
          database.managers.reminder.get(),
        ]);
        return [todo, project, comment, reminder];
      },
      connect: (connection) => SharedDatabase(connection),
    );
    String encoded = jsonEncode(
      {
        "todo": entries[0],
        "project": entries[1],
        "comment": entries[2],
        "reminder": entries[3],
      },
    );
    AppLogger.instance.i("Extracted data from database");
    return encoded;
  }

  Future<void> jsonToDb(String jsonEncoded) async {
    final decoded = jsonDecode(jsonEncoded);
    await Future.wait(
      [
        dbCrudOperations.todo.insert(
          decoded["todo"] as List<dynamic>,
        ),
        dbCrudOperations.project.insert(
          decoded["project"] as List<dynamic>,
        ),
        dbCrudOperations.comment.insert(
          decoded["comment"] as List<dynamic>,
        ),
        dbCrudOperations.reminder.insert(
          decoded["reminder"] as List<dynamic>,
        ),
      ],
    );
    AppLogger.instance.d("Loaded data into database");
  }
}

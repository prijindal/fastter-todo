import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../db/db_crud_operations.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';
import 'confirmation_dialog.dart';

Future<bool> showProjectDeletionDialog(
    BuildContext context, ProjectData project) async {
  final todos = GetIt.I<LocalDbState>()
      .todos
      .where((f) => f.project == project.id)
      .toList();
  String content = "This project have no task, are you sure you want to delete";
  if (todos.isNotEmpty) {
    content =
        "Deleting a project will delete all its tasks. Are you sure you want to continue?";
  }
  final confirmation = await showConfirmationDialog(context,
      title: "Delete project ${project.title}", content: content);
  if (confirmation == true) {
    if (todos.isEmpty) {
      await GetIt.I<DbCrudOperations>().project.delete([project.id]);
    } else {
      await GetIt.I<DbCrudOperations>()
          .todo
          .delete(todos.map((f) => f.id).toList());
      await GetIt.I<DbCrudOperations>().project.delete([project.id]);
    }
    return true;
  }
  return false;
}

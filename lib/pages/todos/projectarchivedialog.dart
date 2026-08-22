import 'package:drift/drift.dart' as drift;
import 'package:get_it/get_it.dart';
import 'package:material_ui/material_ui.dart';

import '../../db/db_crud_operations.dart';
import '../../models/core.dart';
import 'confirmation_dialog.dart';

Future<bool> showProjectArchiveDialog(
    BuildContext context, ProjectData project) async {
  String content =
      "Are you sure you want to archive the project ${project.title}?";
  final confirmation = await showConfirmationDialog(context,
      title: "Archive project ${project.title}", content: content);
  if (confirmation == true) {
    await GetIt.I<DbCrudOperations>().project.update(
        [project.id],
        ProjectCompanion(
          archive: drift.Value(!project.archive),
        ));
    return true;
  }
  return false;
}

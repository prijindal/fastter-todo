import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../db/db_crud_operations.dart';
import '../../../models/core.dart';
import '../../../models/local_db_state.dart';
import '../projectdropdown.dart';

class ChangeProjectButton extends WatchingWidget {
  const ChangeProjectButton({
    super.key,
    required this.selectedTodos,
  });

  final List<TodoData> selectedTodos;

  Future<void> _onChangeProject(
      ProjectData? project, BuildContext context) async {
    await GetIt.I<DbCrudOperations>().todo.update(
        selectedTodos.map((a) => a.id),
        (o) => o(project: drift.Value(project?.id)));
  }

  @override
  Widget build(BuildContext context) {
    final project = watchPropertyValue((LocalDbState state) => state.projects
        .where((p) => p.id == selectedTodos.first.project)
        .firstOrNull);
    if (selectedTodos.isEmpty) {
      return ProjectDropdown(
        onSelected: (p) => _onChangeProject(p, context),
        selectedProject: null,
      );
    }
    return ProjectDropdown(
      onSelected: (p) => _onChangeProject(p, context),
      selectedProject: project,
      enabled: true,
    );
  }
}

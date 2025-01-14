import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/core.dart';
import '../../../models/db_selector.dart';
import '../../../models/local_db_state.dart';
import '../projectdropdown.dart';

class ChangeProjectButton extends StatelessWidget {
  const ChangeProjectButton({
    super.key,
    required this.selectedTodos,
  });

  final List<TodoData> selectedTodos;

  Future<void> _onChangeProject(
      ProjectData? project, BuildContext context) async {
    await Provider.of<DbSelector>(context, listen: false)
        .database
        .managers
        .todo
        .filter((f) => f.id.isIn(selectedTodos.map((a) => a.id)))
        .update((o) => o(project: drift.Value(project?.id)));
  }

  @override
  Widget build(BuildContext context) {
    if (selectedTodos.isEmpty) {
      return ProjectDropdown(
        onSelected: (p) => _onChangeProject(p, context),
        selectedProject: null,
      );
    }
    return Selector<LocalDbState, ProjectData?>(
      selector: (_, state) => state.projects
          .where((p) => p.id == selectedTodos.first.project)
          .firstOrNull,
      builder: (context, project, _) => ProjectDropdown(
        onSelected: (p) => _onChangeProject(p, context),
        selectedProject: project,
      ),
    );
  }
}

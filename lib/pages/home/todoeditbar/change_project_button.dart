import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

import '../../../models/core.dart';
import '../../../models/drift.dart';
import '../projectdropdown.dart';

class ChangeProjectButton extends StatelessWidget {
  const ChangeProjectButton({
    super.key,
    required this.selectedTodos,
  });

  final List<TodoData> selectedTodos;

  Future<void> _onChangeProject(
      ProjectData? project, BuildContext context) async {
    await MyDatabase.instance.managers.todo
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
    return StreamBuilder<ProjectData>(
      stream: MyDatabase.instance.managers.project
          .filter((f) => f.id.equals(selectedTodos.first.project))
          .watchSingle(),
      builder: (context, project) => ProjectDropdown(
        onSelected: (p) => _onChangeProject(p, context),
        selectedProject: project.data,
      ),
    );
  }
}

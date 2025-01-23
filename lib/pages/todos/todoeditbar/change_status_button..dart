import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/core.dart';
import '../../../models/db_manager.dart';
import '../../../models/local_db_state.dart';
import '../status_dialog.dart';

class ChangeStatusButton extends StatelessWidget {
  const ChangeStatusButton({super.key, required this.selectedTodos});
  final List<TodoData> selectedTodos;

  List<String> getAllStatuses(BuildContext context) {
    Set<String>? todos;
    for (var todo in selectedTodos) {
      final projectStatus = Provider.of<LocalDbState>(context, listen: false)
          .getProjectStatuses(todo.project)
          .toSet();
      if (todos == null) {
        todos = projectStatus;
      } else {
        todos = todos.intersection(projectStatus);
      }
    }
    return todos?.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.checklist),
      onPressed: () => _selectStatus(context),
      tooltip: 'Status',
    );
  }

  void _selectStatus(BuildContext context) async {
    final status = await showStatusDialog(context, getAllStatuses(context));
    if (status != null && context.mounted) {
      await Provider.of<DbManager>(context, listen: false)
          .database
          .managers
          .todo
          .filter((f) => f.id.isIn(selectedTodos.map((a) => a.id)))
          .update((o) => o(status: drift.Value(status)));
    }
  }
}

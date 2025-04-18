import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../db/db_crud_operations.dart';
import '../../../models/core.dart';
import '../priority_dialog.dart';

class ChangePriorityButton extends StatelessWidget {
  const ChangePriorityButton({super.key, required this.selectedTodos});
  final List<TodoData> selectedTodos;

  int get _priority {
    int priority = 1;
    for (var todo in selectedTodos) {
      if (todo.priority > priority) {
        priority = todo.priority;
      }
    }
    return priority;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: priorityColors[_priority - 1],
      icon: const Icon(Icons.priority_high),
      onPressed: () => _selectPriority(context),
      tooltip: 'Priority',
    );
  }

  void _selectPriority(BuildContext context) async {
    final priority = await showPriorityDialog(context);
    if (priority != null && context.mounted) {
      await GetIt.I<DbCrudOperations>().todo.update(
          selectedTodos.map((a) => a.id),
          TodoCompanion(priority: drift.Value(priority)));
    }
  }
}

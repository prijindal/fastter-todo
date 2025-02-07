import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../db/db_crud_operations.dart';
import '../../../models/core.dart';
import '../todo_select_date.dart';

class ChangeDateButton extends StatelessWidget {
  const ChangeDateButton({
    super.key,
    required this.selectedTodos,
  });

  final List<TodoData> selectedTodos;

  Future<void> _showDatePicker(BuildContext context) async {
    if (selectedTodos.isNotEmpty && context.mounted) {
      final selectedDate =
          await todoSelectDate(context, selectedTodos.first.dueDate);
      if (selectedDate != null && context.mounted) {
        await GetIt.I<DbCrudOperations>().todo.update(
            selectedTodos.map((a) => a.id),
            (o) => o(dueDate: drift.Value(selectedDate)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.calendar_today,
      ),
      onPressed: () => _showDatePicker(context),
      tooltip: 'Due Date',
    );
  }
}

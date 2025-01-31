import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../models/core.dart';
import '../../../models/db_manager.dart';
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
        await (GetIt.I<DbManager>().database.todo.update()
              ..where((tbl) => tbl.id.isIn(selectedTodos.map((a) => a.id))))
            .write(
          TodoCompanion(
            dueDate: drift.Value(selectedDate),
          ),
        );
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

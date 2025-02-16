import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../db/db_crud_operations.dart';
import '../../../models/core.dart';
import '../../../models/local_state.dart';

class MarkCompletedButton extends StatelessWidget {
  const MarkCompletedButton({super.key});

  void _onMarkCompleted(BuildContext context) async {
    final localStateNotifier = GetIt.I<LocalStateNotifier>();
    await GetIt.I<DbCrudOperations>().todo.update(
        localStateNotifier.selectedTodoIds,
        TodoCompanion(completed: drift.Value(true)));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.check),
      onPressed: () => _onMarkCompleted(context),
      tooltip: 'Completed',
    );
  }
}

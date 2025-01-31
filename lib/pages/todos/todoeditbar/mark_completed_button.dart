import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../models/db_manager.dart';
import '../../../models/local_state.dart';

class MarkCompletedButton extends StatelessWidget {
  const MarkCompletedButton({super.key});

  void _onMarkCompleted(BuildContext context) async {
    final localStateNotifier = GetIt.I<LocalStateNotifier>();
    await GetIt.I<DbManager>()
        .database
        .managers
        .todo
        .filter((f) => f.id.isIn(localStateNotifier.selectedTodoIds))
        .update((o) => o(completed: drift.Value(true)));
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

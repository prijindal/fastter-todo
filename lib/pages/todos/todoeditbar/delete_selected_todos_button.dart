import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../models/db_manager.dart';
import '../../../models/local_state.dart';
import '../confirmation_dialog.dart';

class DeleteSelectedTodosButton extends StatelessWidget {
  const DeleteSelectedTodosButton({super.key});

  void _onDelete(BuildContext context) async {
    final localStateNotifier = GetIt.I<LocalStateNotifier>();
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(),
    );
    if (shouldDelete != null && shouldDelete && context.mounted) {
      await GetIt.I<DbManager>()
          .deleteTodosByIds(localStateNotifier.selectedTodoIds);
      localStateNotifier.clearSelectedTodoIds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onDelete(context),
      icon: Icon(Icons.delete),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/db_manager.dart';
import '../../../models/local_state.dart';
import '../confirmation_dialog.dart';

class DeleteSelectedTodosButton extends StatelessWidget {
  const DeleteSelectedTodosButton({super.key});

  void _onDelete(BuildContext context) async {
    final localStateNotifier =
        Provider.of<LocalStateNotifier>(context, listen: false);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(),
    );
    if (shouldDelete != null && shouldDelete && context.mounted) {
      await Provider.of<DbManager>(context, listen: false)
          .deleteTodosByIds(localStateNotifier.selectedTodoIds);
      localStateNotifier.setSelectedTodoIds([]);
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

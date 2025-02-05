import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../helpers/logger.dart';
import '../../../models/local_db_state.dart';
import '../../../models/local_state.dart';

class CopySelectedTodosButton extends StatelessWidget {
  const CopySelectedTodosButton({super.key});

  void _onShare(BuildContext context) async {
    try {
      final localStateNotifier = GetIt.I<LocalStateNotifier>();
      final text = GetIt.I<LocalDbState>()
          .formTextFromTodos(localStateNotifier.selectedTodoIds);
      await Clipboard.setData(ClipboardData(text: text));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
        ),
      );
    } catch (e, stackTrace) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to share')));
      AppLogger.instance.e(e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onShare(context),
      icon: Icon(Icons.content_copy),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';

import '../../../helpers/logger.dart';
import '../../../models/local_db_state.dart';
import '../../../models/local_state.dart';

class ShareSelectedTodosButton extends StatelessWidget {
  const ShareSelectedTodosButton({super.key});

  void _onShare(BuildContext context) async {
    try {
      final localStateNotifier = GetIt.I<LocalStateNotifier>();
      final text = GetIt.I<LocalDbState>()
          .formTextFromTodos(localStateNotifier.selectedTodoIds);
      final result = await Share.share(text);
      if (result.status == ShareResultStatus.success) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Shared')));
      }
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
      icon: Icon(Icons.share),
    );
  }
}

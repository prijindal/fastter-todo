import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../models/local_state.dart';
import '../todoeditbar/copy_selected_todos_button.dart';
import '../todoeditbar/delete_selected_todos_button.dart';
import '../todoeditbar/share_selected_todos_button.dart';

class SelectedEntriesAppBar extends WatchingWidget {
  const SelectedEntriesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedLength = watchPropertyValue(
        (LocalStateNotifier localState) => localState.selectedTodoIds.length);
    return PopScope(
      canPop: selectedLength == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          // If route did not pop, then it means that the selectedTodoIds is not empty,
          // We need to clear it
          GetIt.I<LocalStateNotifier>().clearSelectedTodoIds();
        }
      },
      child: AppBar(
        leading: IconButton(
          onPressed: () {
            GetIt.I<LocalStateNotifier>().clearSelectedTodoIds();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("$selectedLength Selected"),
        actions: [
          CopySelectedTodosButton(),
          ShareSelectedTodosButton(),
          DeleteSelectedTodosButton(),
        ],
      ),
    );
  }
}

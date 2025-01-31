import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../helpers/todos_filters.dart';
import '../../models/local_state.dart';
import 'todoeditbar/delete_selected_todos_button.dart';

class HomeAppBar extends WatchingWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.filters,
  });

  final TodosFilters filters;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final selectedEntriesEmpty = watchPropertyValue(
        (LocalStateNotifier localState) => localState.selectedTodoIds.isEmpty);
    return selectedEntriesEmpty
        ? MainAppBar(
            filters: filters,
          )
        : const SelectedEntriesAppBar();
  }
}

class MainAppBar extends StatelessWidget {
  const MainAppBar({super.key, required this.filters});

  final TodosFilters filters;

  Widget _buildTitle(BuildContext context) {
    return Text(filters.createTitle(context));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildTitle(context),
      actions: filters.actions
          .map(
            (action) => IconButton(
              onPressed: () => action.onPressed(context),
              icon: action.icon,
            ),
          )
          .toList(),
    );
  }
}

class SelectedEntriesAppBar extends WatchingWidget {
  const SelectedEntriesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localStateNotifier = watchIt<LocalStateNotifier>();
    return PopScope(
      canPop: localStateNotifier.selectedTodoIds.isEmpty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          // If route did not pop, then it means that the selectedTodoIds is not empty,
          // We need to clear it
          localStateNotifier.clearSelectedTodoIds();
        }
      },
      child: AppBar(
        leading: IconButton(
          onPressed: () {
            localStateNotifier.clearSelectedTodoIds();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("${localStateNotifier.selectedTodoIds.length} Selected"),
        actions: [
          DeleteSelectedTodosButton(),
        ],
      ),
    );
  }
}

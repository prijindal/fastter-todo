import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/todos_filters.dart';
import '../../models/local_state.dart';
import 'todoeditbar/delete_selected_todos_button.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.filters,
  });

  final TodosFilters filters;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Selector<LocalStateNotifier, bool>(
      builder: (context, selectedEntriesEmpty, _) => selectedEntriesEmpty
          ? MainAppBar(
              filters: filters,
            )
          : const SelectedEntriesAppBar(),
      selector: (_, localState) => localState.selectedTodoIds.isEmpty,
    );
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

class SelectedEntriesAppBar extends StatelessWidget {
  const SelectedEntriesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localStateNotifier = Provider.of<LocalStateNotifier>(context);
    return PopScope(
      canPop: localStateNotifier.selectedTodoIds.isEmpty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          // If route did not pop, then it means that the selectedTodoIds is not empty,
          // We need to clear it
          localStateNotifier.setSelectedTodoIds([]);
        }
      },
      child: AppBar(
        leading: IconButton(
          onPressed: () {
            localStateNotifier.setSelectedTodoIds([]);
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

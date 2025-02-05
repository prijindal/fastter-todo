import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../helpers/todos_filters.dart';
import '../../../models/local_state.dart';
import 'main_todos_app_bar.dart';
import 'selected_entries_app_bar.dart';

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
        ? MainTodosAppBar(
            filters: filters,
          )
        : const SelectedEntriesAppBar();
  }
}

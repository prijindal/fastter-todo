import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../helpers/todos_filters.dart';
import '../../helpers/todos_sorting_algoritm.dart';
import '../../models/local_db_state.dart';
import '../../models/local_state.dart';
import 'todo_item.dart';
import 'todolistview.dart';

class TodoList extends WatchingWidget {
  const TodoList({
    super.key,
    required this.filters,
  });

  final TodosFilters filters;

  @override
  Widget build(BuildContext context) {
    final isSelected = watchPropertyValue((LocalStateNotifier localState) =>
        localState.selectedTodoIds.isNotEmpty);
    final todos = watchPropertyValue((LocalDbState state) =>
        filters.filtered(state.todos)
          ..sort(TodosSortingAlgorithm.base().compare));
    final isTodosInitialized =
        watchPropertyValue((LocalDbState state) => state.isTodosInitialized);
    return !isTodosInitialized
        ? Center(child: Text("Loading"))
        : TodosListView(
            todos: todos,
            todoItemTapBehaviour: isSelected
                ? TodoItemTapBehaviour.toggleSelection
                : TodoItemTapBehaviour.openTodoBottomSheet,
            todoItemLongPressBehaviour: TodoItemTapBehaviour.toggleSelection,
          );
  }
}

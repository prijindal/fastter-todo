import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_it/watch_it.dart';

import '../../helpers/todos_filters.dart';
import '../../helpers/todos_sorting_algoritm.dart';
import '../../models/core.dart';
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
    return Selector<LocalDbState,
        ({bool isTodosInitialized, List<TodoData> todos})>(
      selector: (context, dbState) => (
        isTodosInitialized: dbState.isTodosInitialized,
        todos: filters.filtered(dbState.todos)
          ..sort(TodosSortingAlgorithm.base().compare),
      ),
      builder: (context, state, _) => !state.isTodosInitialized
          ? Center(child: Text("Loading"))
          : TodosListView(
              todos: state.todos,
              todoItemTapBehaviour: isSelected
                  ? TodoItemTapBehaviour.toggleSelection
                  : TodoItemTapBehaviour.openTodoBottomSheet,
              todoItemLongPressBehaviour: TodoItemTapBehaviour.toggleSelection,
            ),
    );
  }
}

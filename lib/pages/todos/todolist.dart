import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/todos_filters.dart';
import '../../helpers/todos_sorting_algoritm.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';
import '../../models/local_state.dart';
import 'todo_item.dart';
import 'todolistview.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.filters,
  });

  final TodosFilters filters;

  @override
  Widget build(BuildContext context) {
    return Selector2<LocalDbState, LocalStateNotifier,
        ({bool isTodosInitialized, List<TodoData> todos, bool isSelected})>(
      selector: (context, dbState, localState) => (
        isTodosInitialized: dbState.isTodosInitialized,
        todos: filters.filtered(dbState.todos)
          ..sort(TodosSortingAlgorithm.base().compare),
        isSelected: localState.selectedTodoIds.isNotEmpty
      ),
      builder: (context, state, _) => !state.isTodosInitialized
          ? Center(child: Text("Loading"))
          : TodosListView(
              todos: state.todos,
              todoItemTapBehaviour: state.isSelected
                  ? TodoItemTapBehaviour.toggleSelection
                  : TodoItemTapBehaviour.openTodoPage,
              todoItemLongPressBehaviour: TodoItemTapBehaviour.toggleSelection,
            ),
    );
  }
}

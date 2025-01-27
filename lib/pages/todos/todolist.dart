import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/todos_filters.dart';
import '../../helpers/todos_sorting_algoritm.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';
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
    return Selector<LocalDbState,
        ({bool isTodosInitialized, List<TodoData> todos})>(
      selector: (context, state) => (
        isTodosInitialized: state.isTodosInitialized,
        todos: filters.filtered(state.todos)
          ..sort(TodosSortingAlgorithm.base().compare)
      ),
      builder: (context, state, _) => !state.isTodosInitialized
          ? Center(child: Text("Loading"))
          : TodosListView(
              todos: state.todos,
              todoItemTapBehaviour: TodoItemTapBehaviour.toggleSelection,
            ),
    );
  }
}

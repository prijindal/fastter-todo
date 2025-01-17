import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/todos_filters.dart';
import '../../helpers/todos_sorting_algoritm.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.filters,
  });

  final TodosFilters filters;

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalDbState>(
      builder: (context, state, _) => !state.isTodosInitialized
          ? Center(child: Text("Loading"))
          : _TodosList(
              todos: filters.filtered(state.todos)
                ..sort(TodosSortingAlgorithm.base().compare),
            ),
    );
  }
}

class _TodosList extends StatelessWidget {
  const _TodosList({
    required this.todos,
  });

  final List<TodoData> todos;

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return Center(child: Text("Add some entries"));
    }
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 60.0),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItem(
          todo: todo,
        );
      },
    );
  }
}

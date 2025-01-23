import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/todos_filters.dart';
import '../../helpers/todos_sorting_algoritm.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';
import 'todo_item.dart';

class TodoGrid extends StatelessWidget {
  const TodoGrid({super.key, required this.filters});

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
          : _TodosGrid(
              todos: state.todos,
            ),
    );
  }
}

class _TodosGrid extends StatelessWidget {
  _TodosGrid({
    required this.todos,
  });
  final ScrollController _scrollController = ScrollController();

  final List<TodoData> todos;
  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return Center(child: Text("Add some entries"));
    }
    final statuses = todos.map((todo) => todo.status).toSet().toList();
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(bottom: 60.0),
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: statuses.length,
        // ),
        itemCount: statuses.length,
        itemBuilder: (context, statusIndex) {
          final status = statuses[statusIndex];
          final filteredTodos =
              todos.where((todo) => todo.status == status).toList();
          return SizedBox(
            width: 400,
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 60.0),
              itemCount: filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = filteredTodos[index];
                return TodoItem(
                  key: Key("TodoItem${todo.id}"),
                  todo: todo,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

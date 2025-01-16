import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/todos_filters.dart';
import '../../helpers/todos_sorting_algoritm.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';
import '../../models/local_state.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.filters,
  });

  final TodosFilters filters;

  Widget _buildList(BuildContext context, List<TodoData>? entries) {
    if (entries == null) {
      return Center(child: Text("Loading"));
    }
    if (entries.isEmpty) {
      return Center(child: Text("Add some entries"));
    }
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 60.0),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final todo = entries[index];
        return TodoItem(
          todo: todo,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalDbState>(
      builder: (context, state, _) => !state.isTodosInitialized
          ? Center(child: Text("Loading"))
          : Selector<LocalStateNotifier, TodosSortingAlgorithm>(
              selector: (_, state) => state.todosSortingAlgorithm,
              builder: (context, sortingAlgorithm, _) {
                return _buildList(
                  context,
                  filters.filtered(state.todos)..sort(sortingAlgorithm.compare),
                );
              }),
    );
  }
}

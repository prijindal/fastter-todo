import 'package:flutter/material.dart';

import '../../models/core.dart';
import 'todo_item.dart';
import 'todos_filters.dart';

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
    return StreamBuilder<List<TodoData>>(
      key: Key(filters.hashCode.toString()),
      stream: filters.createStream(context),
      builder: (context, entries) => _buildList(context, entries.data),
    );
  }
}

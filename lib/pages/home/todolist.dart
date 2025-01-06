import 'package:flutter/material.dart';

import '../../models/core.dart';
import '../../models/drift.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    this.projectFilter,
  });

  final String? projectFilter;

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

  Stream<List<TodoData>> get _stream {
    var manager =
        MyDatabase.instance.managers.todo.filter((f) => f.id.not.isNull());
    manager = manager.orderBy(
        (o) => o.priority.desc() & o.completed.asc() & o.dueDate.asc());
    if (projectFilter != null) {
      if (projectFilter == "inbox") {
        manager = manager.filter((f) => f.project.isNull());
      } else {
        manager = manager.filter((f) => f.project.equals(projectFilter));
      }
    }
    return manager.watch();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TodoData>>(
      stream: _stream,
      builder: (context, entries) => _buildList(context, entries.data),
    );
  }
}

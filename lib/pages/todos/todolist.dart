import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/core.dart';
import '../../models/db_selector.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    this.projectFilter,
    this.tagFilter,
    this.daysAhead,
  });

  final String? projectFilter;
  final String? tagFilter;
  final int? daysAhead;

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

  Stream<List<TodoData>> _stream(BuildContext context) {
    var manager = Provider.of<DbSelector>(context, listen: false)
        .database
        .managers
        .todo
        .filter((f) => f.id.not.isNull());
    manager = manager.orderBy(
        (o) => o.priority.desc() & o.completed.asc() & o.dueDate.asc());
    if (projectFilter != null) {
      if (projectFilter == "inbox") {
        manager = manager.filter((f) => f.project.isNull());
      } else {
        manager = manager.filter((f) => f.project.equals(projectFilter));
      }
    }
    if (tagFilter != null) {
      manager = manager.filter((f) => f.tags.column.contains(tagFilter!));
    }
    if (daysAhead != null) {
      manager = manager.filter((f) =>
          f.dueDate.isBefore(DateTime.now().add(Duration(days: daysAhead!))));
    }
    return manager.watch();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TodoData>>(
      stream: _stream(context),
      builder: (context, entries) => _buildList(context, entries.data),
    );
  }
}

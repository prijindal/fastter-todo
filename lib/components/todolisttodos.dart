import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/store/state.dart';
import 'package:fastter_dart/store/todos.dart';

import '../components/homeappbar.dart';
import '../components/todoinput.dart';
import '../components/todoitem.dart';
import 'todoeditbar.dart';

class _TodoListTodos extends StatelessWidget {
  const _TodoListTodos({this.categoryView, this.todos});

  final bool categoryView;
  final ListState<Todo> todos;

  String _dueDateCategorize(DateTime dueDate) {
    if (dueDate == null) {
      return 'No Due Date';
    }
    final now = DateTime.now();
    final diff = dueDate.difference(now);
    if (diff.inDays < 0) {
      return 'Overschedule';
    }
    if (diff.inDays < 7) {
      if (dueDate.day == now.day) {
        return 'Today';
      } else if (dueDate.day == now.day + 1) {
        return 'Tomorrow';
      } else {
        return DateFormat.EEEE().format(dueDate);
      }
    } else if (now.year == dueDate.year) {
      return DateFormat.MMM().format(dueDate);
    }
    return DateFormat.yMMM().format(dueDate);
  }

  Widget _buildPendingTodos() {
    if (!categoryView) {
      return Column(
        children: todos.items
            .where((todo) => todo.completed != true)
            .map((todo) => TodoItem(
                  todo: todo,
                ))
            .toList(),
      );
    }
    final mapCategoryToList = <String, List<Todo>>{};

    final items = todos.items.where((todo) => todo.completed != true).toList();

    for (final todo in items) {
      if (todos.sortBy == 'priority') {
        if (!mapCategoryToList.containsKey(todo.priority)) {
          mapCategoryToList[todo.priority.toString()] = [];
        }
        mapCategoryToList[todo.priority.toString()].add(todo);
      } else {
        final dueDateString = _dueDateCategorize(todo.dueDate);
        if (!mapCategoryToList.containsKey(dueDateString)) {
          mapCategoryToList[dueDateString] = [];
        }
        mapCategoryToList[dueDateString].add(todo);
      }
    }

    final children = <ExpansionTile>[];

    for (final categoryString in mapCategoryToList.keys) {
      children.add(
        ExpansionTile(
          initiallyExpanded: true,
          title: Text(categoryString),
          children: mapCategoryToList[categoryString]
              .map((todo) => TodoItem(todo: todo))
              .toList(),
        ),
      );
    }

    return Column(
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPendingTodos();
  }
}

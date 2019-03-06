import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/todo.model.dart';
import '../models/project.model.dart';
import '../store/state.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  TodoItem({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Project>(
      converter: (Store<AppState> store) =>
          store.state.projects.items.isEmpty || todo.project == null
              ? null
              : store.state.projects.items
                  .singleWhere((project) => project.id == todo.project.id),
      builder: (BuildContext context, Project project) {
        return _TodoItem(
          todo: todo,
        );
      },
    );
  }
}

class _TodoItem extends StatelessWidget {
  final Todo todo;

  _TodoItem({
    Key key,
    @required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      subtitle: todo.project == null ? null : Text(todo.project.title),
    );
  }
}

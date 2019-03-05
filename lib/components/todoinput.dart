import 'dart:math';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/todo.model.dart';
import '../store/fastter_action.dart';
import '../store/state.dart';

class TodoInput extends StatelessWidget {
  TodoInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _TodoInput(
          onAddTodo: (todo) => store.dispatch(AddCompletedAction<Todo>(todo)),
        );
      },
    );
  }
}

class _TodoInput extends StatefulWidget {
  final void Function(Todo todo) onAddTodo;

  _TodoInput({Key key, this.onAddTodo}) : super(key: key);

  __TodoInputState createState() => __TodoInputState();
}

class __TodoInputState extends State<_TodoInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: min(400.0, MediaQuery.of(context).size.width - 20.0),
      padding: EdgeInsets.all(4.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: "Add Todo",
        ),
      ),
    );
  }
}

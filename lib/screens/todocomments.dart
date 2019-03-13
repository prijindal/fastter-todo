import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/todocommentitem.dart';
import '../components/todocommentinput.dart';
import '../fastter/fastter_action.dart';
import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../models/todocomment.model.dart';
import '../store/state.dart';

class TodoCommentsScreen extends StatelessWidget {
  const TodoCommentsScreen({
    @required this.todo,
    Key key,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _TodoCommentsScreen(
              todo: todo,
              todoComments: ListState<TodoComment>(
                items: store.state.todoComments.items
                    .where((todocomment) =>
                        todocomment.todo != null &&
                        todocomment.todo.id == todo.id)
                    .toList(),
              ),
              addComment: (TodoComment comment) =>
                  store.dispatch(AddItem<TodoComment>(comment)),
            ),
      );
}

class _TodoCommentsScreen extends StatelessWidget {
  const _TodoCommentsScreen({
    @required this.todo,
    @required this.todoComments,
    @required this.addComment,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final ListState<TodoComment> todoComments;
  final void Function(TodoComment) addComment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Stack(
        children: <Widget>[
          todoComments.items.isEmpty
              ? Container(
                  child: Center(
                    child: Text("No Comments"),
                  ),
                )
              : ListView(
                  children: todoComments.items
                      .map(
                        (todoComment) => TodoCommentItem(
                              todoComment: todoComment,
                            ),
                      )
                      .toList(),
                ),
          Positioned(
            bottom: 0,
            left: 0,
            child: TodoCommentInput(
              todo: todo,
            ),
          )
        ],
      ),
    );
  }
}

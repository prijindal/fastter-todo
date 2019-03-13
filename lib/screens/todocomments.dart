import 'dart:math';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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

class _TodoCommentsScreen extends StatefulWidget {
  const _TodoCommentsScreen({
    @required this.todo,
    @required this.todoComments,
    @required this.addComment,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final ListState<TodoComment> todoComments;
  final void Function(TodoComment) addComment;

  _TodoCommentsScreenState createState() => _TodoCommentsScreenState();
}

class _TodoCommentsScreenState extends State<_TodoCommentsScreen> {
  TextEditingController commentContentController = TextEditingController();

  void _addComment() {
    widget.addComment(
      TodoComment(
        content: commentContentController.text,
        todo: widget.todo,
      ),
    );
    commentContentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo.title),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: widget.todoComments.items
                .map(
                  (comment) => ListTile(
                        title: Text(comment.content),
                      ),
                )
                .toList(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Material(
              elevation: 4,
              child: Container(
                color: Colors.white,
                width:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.width -
                            304, // 304 is the _kWidth of drawer,
                child: Center(
                  child: Container(
                    width: min(480, MediaQuery.of(context).size.width - 20.0),
                    padding: const EdgeInsets.all(4),
                    child: Form(
                      child: TextFormField(
                        controller: commentContentController,
                        decoration: InputDecoration(
                          labelText: "Add new comment",
                        ),
                        onFieldSubmitted: (title) {
                          _addComment();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:math';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../fastter/fastter_action.dart';
import '../models/todo.model.dart';
import '../models/todocomment.model.dart';
import '../store/state.dart';

class TodoCommentInput extends StatelessWidget {
  const TodoCommentInput({
    @required this.todo,
    this.onAdded,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final VoidCallback onAdded;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _TodoCommentInput(
              todo: todo,
              addComment: (TodoComment comment) {
                store.dispatch(AddItem<TodoComment>(comment));
                if (onAdded != null) {
                  onAdded();
                }
              },
            ),
      );
}

class _TodoCommentInput extends StatefulWidget {
  const _TodoCommentInput({
    @required this.todo,
    @required this.addComment,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final void Function(TodoComment) addComment;

  _TodoCommentInputState createState() => _TodoCommentInputState();
}

class _TodoCommentInputState extends State<_TodoCommentInput> {
  TextEditingController commentContentController = TextEditingController();

  void _addComment() {
    widget.addComment(
      TodoComment(
        content: commentContentController.text,
        todo: widget.todo,
        createdAt: DateTime.now(),
      ),
    );
    commentContentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
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
    );
  }
}

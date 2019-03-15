import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import 'package:fastter_dart/store/state.dart';
import 'image_picker.dart';

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

enum TodoCommentInputAttachmentType { image }

class _TodoCommentInputState extends State<_TodoCommentInput> {
  TextEditingController commentContentController = TextEditingController();

  void _addImageComment() {
    ImagePickerUploader(
      context: context,
      value: null,
      storagePath: 'todocomments/${Uuid().v1()}.jpg',
      onError: (error) {},
      onChange: (value) {
        if (value != null && value.isNotEmpty) {
          widget.addComment(
            TodoComment(
              content: value,
              type: TodoCommentType.image,
              todo: widget.todo,
              createdAt: DateTime.now(),
            ),
          );
        }
      },
    ).editPicture();
  }

  void _addComment() {
    if (commentContentController.text.isNotEmpty) {
      widget.addComment(
        TodoComment(
          content: commentContentController.text,
          type: TodoCommentType.text,
          todo: widget.todo,
          createdAt: DateTime.now(),
        ),
      );
    }
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
              child: TextField(
                controller: commentContentController,
                decoration: InputDecoration(
                  labelText: "Add new comment",
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PopupMenuButton<TodoCommentInputAttachmentType>(
                        onSelected: (selected) {
                          if (selected ==
                              TodoCommentInputAttachmentType.image) {
                            _addImageComment();
                          }
                        },
                        child: Icon(Icons.attach_file),
                        itemBuilder: (context) => [
                              PopupMenuItem<TodoCommentInputAttachmentType>(
                                value: TodoCommentInputAttachmentType.image,
                                child: ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("Image"),
                                ),
                              ),
                            ],
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: commentContentController.text.isNotEmpty
                            ? _addComment
                            : null,
                      ),
                    ],
                  ),
                ),
                onSubmitted: commentContentController.text.isNotEmpty
                    ? (title) => _addComment()
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

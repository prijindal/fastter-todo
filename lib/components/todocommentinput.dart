import 'dart:math';
import '../store/todocomments.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import '../fastter/fastter_bloc.dart';
import '../models/todo.model.dart';
import '../models/todocomment.model.dart';
import 'image_picker.dart';
import 'video_picker.dart';

class TodoCommentInput extends StatelessWidget {
  const TodoCommentInput({
    required this.todo,
    required this.onAdded,
    super.key,
  });

  final Todo todo;
  final VoidCallback onAdded;

  @override
  Widget build(BuildContext context) => _TodoCommentInput(
        todo: todo,
        addComment: (comment) {
          fastterTodoComments.add(AddEvent<TodoComment>(comment));
          if (onAdded != null) {
            onAdded();
          }
        },
      );
}

class _TodoCommentInput extends StatefulWidget {
  const _TodoCommentInput({
    required this.todo,
    required this.addComment,
  });

  final Todo todo;
  final void Function(TodoComment) addComment;

  @override
  _TodoCommentInputState createState() => _TodoCommentInputState();
}

enum TodoCommentInputAttachmentType { image, video }

class _TodoCommentInputState extends State<_TodoCommentInput> {
  TextEditingController commentContentController = TextEditingController();

  void _addImageComment() {
    // ImagePickerUploader(
    //   context: context,
    //   text: 'Upload Image',
    //   value: null,
    //   storagePath: 'todocomments/${Uuid().v1()}.jpg',
    //   onError: (dynamic error) {},
    //   onChange: (value) {
    //     if (value != null && value.isNotEmpty) {
    //       widget.addComment(
    //         TodoComment(
    //           content: value,
    //           type: TodoCommentType.image,
    //           todo: widget.todo,
    //           createdAt: DateTime.now(),
    //         ),
    //       );
    //     }
    //   },
    // ).editPicture();
  }

  void _addVideoComment() {
    // VideoPickerUploader(
    //   context: context,
    //   storagePath: 'todocomments/${Uuid().v1()}.mp4',
    //   onError: (dynamic error) {},
    //   onChange: (value) {
    //     if (value != null && value.isNotEmpty) {
    //       widget.addComment(
    //         TodoComment(
    //           content: value,
    //           type: TodoCommentType.video,
    //           todo: widget.todo,
    //           createdAt: DateTime.now(),
    //         ),
    //       );
    //     }
    //   },
    // ).editVideo();
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
  Widget build(BuildContext context) => Material(
        elevation: 4,
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              width: min(480, MediaQuery.of(context).size.width - 20.0),
              padding: const EdgeInsets.all(4),
              child: Form(
                onChanged: () {
                  setState(() {});
                },
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: commentContentController,
                        decoration: InputDecoration(
                          labelText: 'Add new comment',
                        ),
                        onFieldSubmitted:
                            commentContentController.text.isNotEmpty
                                ? (title) => _addComment()
                                : null,
                      ),
                    ),
                    PopupMenuButton<TodoCommentInputAttachmentType>(
                      onSelected: (selected) {
                        if (selected == TodoCommentInputAttachmentType.image) {
                          _addImageComment();
                        } else if (selected ==
                            TodoCommentInputAttachmentType.video) {
                          _addVideoComment();
                        }
                      },
                      child: const Icon(Icons.attach_file),
                      itemBuilder: (context) => [
                        PopupMenuItem<TodoCommentInputAttachmentType>(
                          value: TodoCommentInputAttachmentType.image,
                          child: ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text('Image'),
                          ),
                        ),
                        PopupMenuItem<TodoCommentInputAttachmentType>(
                          value: TodoCommentInputAttachmentType.video,
                          child: ListTile(
                            leading: const Icon(Icons.videocam),
                            title: const Text('Video'),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: commentContentController.text.isNotEmpty
                          ? _addComment
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

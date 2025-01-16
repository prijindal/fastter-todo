import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/core.dart';
import '../../models/db_manager.dart';

class TodoCommentInput extends StatefulWidget {
  const TodoCommentInput({
    super.key,
    required this.todo,
    required this.onAdded,
  });

  final TodoData todo;
  final VoidCallback onAdded;

  @override
  State<TodoCommentInput> createState() => _TodoCommentInputState();
}

class _TodoCommentInputState extends State<TodoCommentInput> {
  TextEditingController commentContentController = TextEditingController();

  void _addComment() async {
    await Provider.of<DbManager>(context, listen: false)
        .database
        .managers
        .comment
        .create(
          (f) => f(
            type: TodoCommentType.text,
            content:
                Uint8List.fromList(commentContentController.text.codeUnits),
            todo: widget.todo.id,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  onFieldSubmitted: commentContentController.text.isNotEmpty
                      ? (title) => _addComment()
                      : null,
                ),
              ),
              // PopupMenuButton<TodoCommentInputAttachmentType>(
              //   onSelected: (selected) {
              //     if (selected == TodoCommentInputAttachmentType.image) {
              //       _addImageComment();
              //     } else if (selected == TodoCommentInputAttachmentType.video) {
              //       _addVideoComment();
              //     }
              //   },
              //   child: const Icon(Icons.attach_file),
              //   itemBuilder: (context) => [
              //     PopupMenuItem<TodoCommentInputAttachmentType>(
              //       value: TodoCommentInputAttachmentType.image,
              //       child: ListTile(
              //         leading: const Icon(Icons.image),
              //         title: const Text('Image'),
              //       ),
              //     ),
              //     PopupMenuItem<TodoCommentInputAttachmentType>(
              //       value: TodoCommentInputAttachmentType.video,
              //       child: ListTile(
              //         leading: const Icon(Icons.videocam),
              //         title: const Text('Video'),
              //       ),
              //     ),
              //   ],
              // ),
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
    );
  }
}

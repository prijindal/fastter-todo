import 'dart:math';
import 'dart:typed_data';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';

import '../../db/db_crud_operations.dart';
import '../../models/core.dart';

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
  final _formKey = GlobalKey<FormBuilderState>();

  void _addComment() async {
    if (_formKey.currentState?.saveAndValidate() == true) {
      final comment = _formKey.currentState!.value;
      final content =
          Uint8List.fromList((comment["content"] as String).codeUnits);
      await GetIt.I<DbCrudOperations>().comment.create(
            CommentCompanion(
              type: drift.Value(TodoCommentType.text),
              content: drift.Value(content),
              todo: drift.Value(widget.todo.id),
              created_at: drift.Value(DateTime.now()),
            ),
          );
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: min(480, MediaQuery.of(context).size.width - 20.0),
        padding: const EdgeInsets.all(4),
        child: FormBuilder(
          key: _formKey,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: FormBuilderTextField(
                  name: "content",
                  decoration: InputDecoration(
                    labelText: 'Add new comment',
                  ),
                  onSubmitted: (_) => _addComment(),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
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
                onPressed: () => _addComment(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

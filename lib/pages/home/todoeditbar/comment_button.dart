import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../models/core.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({super.key, required this.todo});

  final TodoData todo;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.comment),
      onPressed: () {
        AutoRouter.of(context).pushNamed("/todocomments/${todo.id}");
      },
      tooltip: 'Comments',
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../models/core.dart';

class SubtaskButton extends StatelessWidget {
  const SubtaskButton({super.key, required this.todo});

  final TodoData todo;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.format_strikethrough),
      onPressed: () {
        AutoRouter.of(context).pushNamed("/todochildren/${todo.id}");
      },
      tooltip: 'Sub Tasks',
    );
  }
}

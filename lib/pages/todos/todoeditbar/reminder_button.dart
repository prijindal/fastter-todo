import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../models/core.dart';

class ReminderButton extends StatelessWidget {
  const ReminderButton({super.key, required this.todo});

  final TodoData todo;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.alarm),
      onPressed: () {
        AutoRouter.of(context).pushPath("/todoreminders/${todo.id}");
      },
      tooltip: 'Reminders',
    );
  }
}

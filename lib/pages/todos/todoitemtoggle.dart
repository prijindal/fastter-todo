import 'package:flutter/material.dart';

import '../../models/core.dart';
import 'priority_dialog.dart' show priorityColors;

class TodoItemToggle extends StatelessWidget {
  const TodoItemToggle({
    super.key,
    required this.todo,
    required this.toggleCompleted,
  });
  final TodoData todo;
  final ValueChanged<bool> toggleCompleted;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          toggleCompleted(!(todo.completed == true));
        },
        child: Container(
          constraints: const BoxConstraints.expand(
            width: 48,
            height: 48,
          ),
          child: Center(
            child: AnimatedContainer(
              constraints: const BoxConstraints(
                maxWidth: 20,
                maxHeight: 20,
              ),
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: (todo.completed == true)
                    ? Theme.of(context).tabBarTheme.indicatorColor
                    : Colors.transparent,
                border: Border.all(
                  color: priorityColors[todo.priority - 1],
                  width: todo.priority.toDouble(),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(18)),
              ),
            ),
          ),
        ),
      );
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../models/core.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key, required this.todo});

  final TodoData todo;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        AutoRouter.of(context).pushNamed("/todo/${todo.id}");
      },
      tooltip: 'Edit Todo',
    );
  }
}

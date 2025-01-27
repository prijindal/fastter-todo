import 'package:flutter/material.dart';

import '../../../models/core.dart';
import '../../todo/index.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key, required this.todo});

  final TodoData todo;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        TodoScreen.open(context, todo);
      },
      tooltip: 'Edit Todo',
    );
  }
}

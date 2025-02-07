import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../db/db_crud_operations.dart';
import '../../../models/core.dart';
import '../../../models/local_db_state.dart';
import '../pipeline_dialog.dart';

class ChangePipelineButton extends StatelessWidget {
  const ChangePipelineButton({super.key, required this.selectedTodos});
  final List<TodoData> selectedTodos;

  List<String> getAllPipelines(BuildContext context) {
    Set<String>? todos;
    for (var todo in selectedTodos) {
      final projectPipeline =
          GetIt.I<LocalDbState>().getProjectPipelines(todo.project).toSet();
      if (todos == null) {
        todos = projectPipeline;
      } else {
        todos = todos.intersection(projectPipeline);
      }
    }
    return todos?.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.checklist),
      onPressed: () => _selectPipeline(context),
      tooltip: 'Pipeline',
    );
  }

  void _selectPipeline(BuildContext context) async {
    final pipeline =
        await showPipelineDialog(context, getAllPipelines(context));
    if (pipeline != null && context.mounted) {
      await GetIt.I<DbCrudOperations>().todo.update(
          selectedTodos.map((a) => a.id),
          (o) => o(pipeline: drift.Value(pipeline)));
    }
  }
}

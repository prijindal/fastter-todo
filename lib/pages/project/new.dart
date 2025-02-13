import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../db/db_crud_operations.dart';
import '../../helpers/todos_filters.dart';
import '../../models/core.dart';
import 'form.dart';

@RoutePage()
class NewProjectScreen extends StatelessWidget {
  const NewProjectScreen({
    super.key,
  });

  void _onSave(
    BuildContext context, {
    String? title,
    Color? color,
    List<String>? pipelines,
  }) async {
    if (title == null || color == null) {
      return;
    }
    final project = await GetIt.I<DbCrudOperations>().project.create(
          (o) => o(
            color: color.hex,
            title: title,
            pipelines: drift.Value(pipelines ?? [defaultPipeline]),
          ),
        );
    // ignore: use_build_context_synchronously
    AutoRouter.of(context).navigateNamed(
        "/todos/?${TodosFilters(projectFilter: project.id).queryString}");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Add new project'),
        ),
        body: ProjectForm(
          onSave: ({title, color, pipelines}) => _onSave(
            context,
            title: title,
            color: color,
            pipelines: pipelines,
          ),
        ),
      );
}

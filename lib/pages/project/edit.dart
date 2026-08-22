import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:watch_it/watch_it.dart';

import '../../db/db_crud_operations.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';
import 'form.dart';

@RoutePage()
class EditProjectScreen extends WatchingWidget {
  const EditProjectScreen({
    super.key,
    @pathParam required this.projectId,
  });

  final String projectId;
  @override
  Widget build(BuildContext context) {
    final project = watchPropertyValue((LocalDbState state) =>
        state.projects.where((a) => a.id == projectId).firstOrNull);
    return project == null
        ? Scaffold(body: Center(child: Text("Loading...")))
        : _EditProjectScreen(
            project: project,
          );
  }
}

class _EditProjectScreen extends StatelessWidget {
  const _EditProjectScreen({
    required this.project,
  });

  final ProjectData project;

  void _onSave(
    BuildContext context, {
    String? title,
    Color? color,
    bool? archive,
    List<String>? pipelines,
  }) async {
    await GetIt.I<DbCrudOperations>().project.update(
        [project.id],
        ProjectCompanion(
          color: drift.Value(color?.hex ?? project.color),
          title: drift.Value(title ?? project.title),
          archive: drift.Value(archive ?? project.archive),
          pipelines: drift.Value(pipelines ?? project.pipelines),
        ));
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Edit ${project.title}'),
        ),
        body: ProjectForm(
          title: project.title,
          color: project.color,
          archive: project.archive,
          pipelines: project.pipelines,
          onSave: ({title, color, archive, pipelines}) => _onSave(
            context,
            title: title,
            archive: archive,
            color: color,
            pipelines: pipelines,
          ),
        ),
      );
}

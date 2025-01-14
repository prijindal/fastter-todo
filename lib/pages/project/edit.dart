import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../models/core.dart';
import '../../models/db_selector.dart';
import 'form.dart';

@RoutePage()
class EditProjectScreen extends StatelessWidget {
  const EditProjectScreen({
    super.key,
    @pathParam required this.projectId,
  });

  final String projectId;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProjectData>(
      future: Provider.of<DbSelector>(context, listen: false)
          .database
          .managers
          .project
          .filter((f) => f.id.equals(projectId))
          .getSingle(),
      builder: (_, snapshot) => (!snapshot.hasData)
          ? Scaffold(body: Center(child: Text("Loading...")))
          : _EditProjectScreen(
              project: snapshot.requireData,
            ),
    );
  }
}

class _EditProjectScreen extends StatelessWidget {
  const _EditProjectScreen({
    required this.project,
  });

  final ProjectData project;

  void _onSave(BuildContext context, {String? title, HexColor? color}) async {
    await Provider.of<DbSelector>(context, listen: false)
        .database
        .managers
        .project
        .filter((f) => f.id.equals(project.id))
        .update(
          (o) => o(
            color: drift.Value(color?.hex ?? project.color),
            title: drift.Value(title ?? project.title),
          ),
        );
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
          onSave: ({title, color}) => _onSave(
            context,
            title: title,
            color: color,
          ),
        ),
      );
}

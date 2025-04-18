import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:watch_it/watch_it.dart';

import '../../components/adaptive_scaffold.dart';
import '../../components/main_drawer.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';

@RoutePage()
class ProjectsScreen extends WatchingWidget {
  const ProjectsScreen({super.key});

  Widget _buildBody(BuildContext context, List<ProjectData>? projects) {
    if (projects == null) {
      return Center(
        child: Text("Loading"),
      );
    }
    if (projects.isEmpty) {
      return Center(
        child: Text("Add a project"),
      );
    }
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectListTile(
          project: project,
          onTap: () =>
              AutoRouter.of(context).pushPath("/project/${project.id}"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects = watchPropertyValue((LocalDbState state) => state.projects);
    return AdaptiveScaffold(
      appBar: AppBar(
        title: Text("Projects"),
      ),
      drawer: MainDrawer(),
      body: _buildBody(context, projects),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AutoRouter.of(context).pushPath("/newproject");
        },
        tooltip: 'New Journal',
        key: Key("New Journal"),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProjectListTile extends StatelessWidget {
  const ProjectListTile({
    super.key,
    required this.project,
    this.onTap,
  });

  final ProjectData project;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.group_work,
        color: HexColor(project.color),
      ),
      title: Text(project.title),
      onTap: onTap,
    );
  }
}

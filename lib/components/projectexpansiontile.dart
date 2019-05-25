import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/store/projects.dart';
import 'package:fastter_dart/store/todos.dart' show fastterTodos;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fastter_dart/models/project.model.dart';

import '../components/hexcolor.dart';
import '../helpers/todofilters.dart';
import '../screens/addproject.dart';
import '../screens/manageprojects.dart';
import 'expansiontile.dart';

class ProjectExpansionTile extends StatelessWidget {
  const ProjectExpansionTile({
    @required this.onChildSelected,
    this.selectedProject,
    Key key,
  }) : super(key: key);

  final Project selectedProject;
  final void Function(Project) onChildSelected;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterEvent<Project>, ListState<Project>>(
        bloc: fastterProjects,
        builder: (context, state) {
          final todos = fastterTodos.currentState;
          return BaseExpansionTile<Project>(
            liststate: state.copyWith(
              items: state.items..sort(getCompareFunction('index')),
            ),
            addRoute: MaterialPageRoute<void>(
              builder: (context) => AddProjectScreen(),
            ),
            manageRoute: MaterialPageRoute(
              builder: (context) => ManageProjectsScreen(),
            ),
            icon: const Icon(Icons.group_work),
            title: 'Projects',
            buildChild: (project) => ListTile(
                  dense: true,
                  enabled: selectedProject == null ||
                      selectedProject.id != project.id,
                  selected: selectedProject != null &&
                      selectedProject.id == project.id,
                  leading: Icon(
                    Icons.group_work,
                    color:
                        project.color == null ? null : HexColor(project.color),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        constraints:
                            const BoxConstraints(maxWidth: 200, maxHeight: 40),
                        child: Text(project.title),
                      ),
                      Text(filterToCount(
                        <String, dynamic>{
                          'project': project.id,
                        },
                        todos,
                      ).toString()),
                    ],
                  ),
                  onTap: () => onChildSelected(project),
                ),
          );
        },
      );
}

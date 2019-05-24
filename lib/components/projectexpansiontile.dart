import 'package:fastter_dart/store/projects.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/store/state.dart';

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
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          final todos = store.state.todos;
          return BaseExpansionTile<Project>(
            liststate: store.state.projects.copyWith(
              items: store.state.projects.items
                ..sort(getCompareFunction('index')),
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

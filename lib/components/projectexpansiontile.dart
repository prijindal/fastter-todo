import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/hexcolor.dart';
import '../fastter/fastter_bloc.dart';
import '../models/base.model.dart';
import '../models/project.model.dart';
import '../screens/addproject.dart';
import '../screens/manageprojects.dart';
import '../store/projects.dart';

import 'expansiontile.dart';
import 'filtercountext.dart';

class ProjectExpansionTile extends StatelessWidget {
  const ProjectExpansionTile({
    super.key,
    required this.onChildSelected,
    this.selectedProject,
  });

  final Project? selectedProject;
  final void Function(Project) onChildSelected;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterBloc<Project>, ListState<Project>>(
        bloc: fastterProjects,
        builder: (context, state) => BaseExpansionTile<Project>(
          liststate: state.copyWith(
            items: state.items..sort(getCompareFunction('index')),
          ),
          addRoute: MaterialPageRoute<void>(
            builder: (context) => const AddProjectScreen(),
          ),
          manageRoute: MaterialPageRoute(
            builder: (context) => ManageProjectsScreen(),
          ),
          icon: const Icon(Icons.group_work),
          title: 'Projects',
          buildChild: (project) => ListTile(
            dense: true,
            enabled:
                selectedProject == null || selectedProject?.id != project.id,
            selected:
                selectedProject != null && selectedProject?.id == project.id,
            leading: Icon(
              Icons.group_work,
              color: project.color == null ? null : HexColor(project.color),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints:
                      const BoxConstraints(maxWidth: 200, maxHeight: 40),
                  child: Text(project.title),
                ),
                FilterCountText(
                  <String, dynamic>{
                    'project': project.id,
                  },
                ),
              ],
            ),
            onTap: () => onChildSelected(project),
          ),
        ),
      );
}

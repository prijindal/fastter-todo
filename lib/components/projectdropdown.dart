import '../fastter/fastter_bloc.dart';
import '../store/projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/base.model.dart';
import '../models/project.model.dart';

import '../components/hexcolor.dart';

class ProjectDropdown extends StatelessWidget {
  const ProjectDropdown({
    super.key,
    required this.onSelected,
    this.selectedProject,
    this.onOpening,
    this.expanded = false,
  });

  final bool expanded;
  final void Function(Project?) onSelected;
  final Project? selectedProject;
  final void Function()? onOpening;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterBloc<Project>, ListState<Project>>(
        bloc: fastterProjects,
        builder: (context, state) => _ProjectDropdown(
          projects: state,
          onSelected: onSelected,
          selectedProject: selectedProject,
          onOpening: onOpening,
          expanded: expanded,
        ),
      );
}

class _ProjectDropdown extends StatelessWidget {
  _ProjectDropdown({
    required this.projects,
    required this.onSelected,
    this.selectedProject,
    this.onOpening,
    this.expanded = false,
  });

  final GlobalKey _menuKey = GlobalKey();
  final bool expanded;
  final ListState<Project> projects;
  final void Function(Project?) onSelected;
  final Project? selectedProject;
  final void Function()? onOpening;

  RelativeRect _getPosition(BuildContext context) {
    if (onOpening != null) {
      onOpening!();
    }
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    final RenderBox? renderBox =
        _menuKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox != null && overlay != null
        ? RelativeRect.fromRect(
            Rect.fromPoints(
              renderBox.localToGlobal(Offset.zero, ancestor: overlay),
              renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero),
                  ancestor: overlay),
            ),
            Offset.zero & overlay.size,
          )
        : const RelativeRect.fromLTRB(0, 0, 0, 0);
  }

  void _showMenu(BuildContext context) {
    showMenu<Project>(
      position: _getPosition(context),
      initialValue: selectedProject,
      context: context,
      items: projects.items
          .map((project) => PopupMenuItem<Project>(
                value: project,
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelected(project);
                  },
                  leading: Icon(
                    Icons.group_work,
                    color: HexColor(project.color),
                  ),
                  title: Text(project.title),
                ),
              ))
          .toList()
        ..add(PopupMenuItem<Project>(
          value: null,
          child: ListTile(
            onTap: () {
              Navigator.of(context).pop();
              onSelected(null);
            },
            leading: const Icon(
              Icons.group_work,
            ),
            title: const Text('Inbox'),
          ),
        )),
    );
  }

  Icon _buildIcon() => Icon(
        Icons.group_work,
        color:
            selectedProject == null ? null : HexColor(selectedProject!.color),
      );

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return ListTile(
        key: _menuKey,
        leading: _buildIcon(),
        title: const Text('Project'),
        subtitle:
            Text(selectedProject == null ? 'Inbox' : selectedProject!.title),
        onTap: () => _showMenu(context),
      );
    }
    return IconButton(
      key: _menuKey,
      icon: _buildIcon(),
      onPressed: () => _showMenu(context),
      tooltip: 'Project',
    );
  }
}

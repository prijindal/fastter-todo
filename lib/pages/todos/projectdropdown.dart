import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../models/core.dart';
import '../../models/local_db_state.dart';

class ProjectDropdown extends StatelessWidget {
  const ProjectDropdown({
    super.key,
    required this.onSelected,
    this.selectedProject,
    this.onOpening,
    this.expanded = false,
  });

  final bool expanded;
  final void Function(ProjectData?) onSelected;
  final ProjectData? selectedProject;
  final void Function()? onOpening;

  @override
  Widget build(BuildContext context) {
    return Selector<LocalDbState, List<ProjectData>>(
      selector: (_, state) => state.projects,
      builder: (context, projects, _) => _ProjectDropdown(
        projects: projects,
        onSelected: onSelected,
        selectedProject: selectedProject,
        onOpening: onOpening,
        expanded: expanded,
      ),
    );
  }
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
  final List<ProjectData> projects;
  final void Function(ProjectData?) onSelected;
  final ProjectData? selectedProject;
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
    showMenu<ProjectData>(
      position: _getPosition(context),
      initialValue: selectedProject,
      context: context,
      items: projects
          .map((project) => PopupMenuItem<ProjectData>(
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
        ..add(PopupMenuItem<ProjectData>(
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

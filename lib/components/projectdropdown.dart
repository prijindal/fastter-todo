import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/store/state.dart';

import '../components/hexcolor.dart';

class ProjectDropdown extends StatelessWidget {
  const ProjectDropdown({
    @required this.onSelected,
    this.selectedProject,
    this.onOpening,
    this.expanded = false,
  });

  final bool expanded;
  final void Function(Project) onSelected;
  final Project selectedProject;
  final void Function() onOpening;
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _ProjectDropdown(
              projects: store.state.projects,
              onSelected: onSelected,
              selectedProject: selectedProject,
              onOpening: onOpening,
              expanded: expanded,
            ),
      );
}

class _ProjectDropdown extends StatelessWidget {
  _ProjectDropdown({
    @required this.projects,
    @required this.onSelected,
    this.selectedProject,
    this.onOpening,
    this.expanded = false,
    Key key,
  }) : super(key: key);

  final GlobalKey _menuKey = GlobalKey();
  final bool expanded;
  final ListState<Project> projects;
  final void Function(Project) onSelected;
  final Project selectedProject;
  final void Function() onOpening;

  RelativeRect _getPosition(BuildContext context) {
    if (onOpening != null) {
      onOpening();
    }
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RenderBox renderBox = _menuKey.currentContext.findRenderObject();
    return RelativeRect.fromRect(
      Rect.fromPoints(
        renderBox.localToGlobal(Offset.zero, ancestor: overlay),
        renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
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
        color: selectedProject == null ? null : HexColor(selectedProject.color),
      );

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return ListTile(
        key: _menuKey,
        leading: _buildIcon(),
        title: const Text('Project'),
        subtitle:
            Text(selectedProject == null ? 'Inbox' : selectedProject.title),
        onTap: () => _showMenu(context),
      );
    }
    return IconButton(
      key: _menuKey,
      icon: _buildIcon(),
      onPressed: () => _showMenu(context),
    );
  }
}

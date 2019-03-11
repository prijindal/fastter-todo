import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/base.model.dart';
import '../models/project.model.dart';
import '../store/state.dart';
import '../components/hexcolor.dart';

class ProjectDropdown extends StatelessWidget {
  final bool expanded;
  final void Function(Project) onSelected;
  final Project selectedProject;
  final void Function() onOpening;

  ProjectDropdown({
    @required this.onSelected,
    this.selectedProject,
    this.onOpening,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _ProjectDropdown(
          projects: store.state.projects,
          onSelected: onSelected,
          selectedProject: selectedProject,
          onOpening: onOpening,
          expanded: expanded,
        );
      },
    );
  }
}

class _ProjectDropdown extends StatelessWidget {
  final GlobalKey _menuKey = GlobalKey();

  _ProjectDropdown({
    Key key,
    @required this.projects,
    @required this.onSelected,
    this.selectedProject,
    this.onOpening,
    this.expanded = false,
  }) : super(key: key);

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

  _showMenu(BuildContext context) {
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
                leading: Icon(
                  Icons.group_work,
                ),
                title: Text("Inbox"),
              ),
            )),
    );
  }

  Icon _buildIcon() {
    return Icon(
      Icons.group_work,
      color: selectedProject == null ? null : HexColor(selectedProject.color),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return ListTile(
        key: _menuKey,
        leading: _buildIcon(),
        title: Text("Project"),
        subtitle:
            Text(selectedProject == null ? "Inbox" : selectedProject.title),
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

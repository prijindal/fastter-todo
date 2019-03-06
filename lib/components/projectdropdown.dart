import 'dart:math' as math;
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../models/project.model.dart';
import '../fastter/fastter_action.dart';
import '../store/state.dart';
import '../components/hexcolor.dart';

class ProjectDropdown extends StatelessWidget {
  final void Function(Project) onSelected;

  ProjectDropdown({@required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _ProjectDropdown(
          projects: store.state.projects,
          syncStart: () => store.dispatch(StartSync<Project>()),
          onSelected: onSelected,
        );
      },
    );
  }
}

class _ProjectDropdown extends StatefulWidget {
  _ProjectDropdown({
    Key key,
    @required this.projects,
    @required this.syncStart,
    @required this.onSelected,
  }) : super(key: key);

  final VoidCallback syncStart;
  final ListState<Project> projects;
  final void Function(Project) onSelected;

  _ProjectDropdownState createState() => _ProjectDropdownState();
}

class _ProjectDropdownState extends State<_ProjectDropdown> {
  @override
  void initState() {
    super.initState();
    widget.syncStart();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Project>(
      icon: Icon(Icons.group_work),
      itemBuilder: (BuildContext context) => widget.projects.items
          .map((project) => PopupMenuItem<Project>(
                value: project,
                child: ListTile(
                  leading: Icon(
                    Icons.group_work,
                    color: HexColor(project.color),
                  ),
                  title: Text(project.title),
                ),
              ))
          .toList(),
      onSelected: widget.onSelected,
    );
  }
}

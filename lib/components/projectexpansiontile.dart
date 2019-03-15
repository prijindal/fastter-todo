import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/hexcolor.dart';
import '../helpers/navigator.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import '../screens/addproject.dart';
import 'package:fastter_dart/store/state.dart';
import '../screens/manageprojects.dart';

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
        builder: (context, store) => _ProjectExpansionTile(
              projects: store.state.projects,
              todos: ListState<Todo>(
                items: store.state.todos.items
                    .where((todo) => todo.completed != true)
                    .toList(),
              ),
              onChildSelected: onChildSelected,
              selectedProject: selectedProject,
            ),
      );
}

class _ProjectExpansionTile extends StatefulWidget {
  const _ProjectExpansionTile({
    @required this.projects,
    @required this.todos,
    @required this.onChildSelected,
    this.selectedProject,
  });

  final ListState<Project> projects;
  final ListState<Todo> todos;
  final Project selectedProject;
  final void Function(Project) onChildSelected;

  @override
  _ProjectExpansionTileState createState() => _ProjectExpansionTileState();
}

class _ProjectExpansionTileState extends State<_ProjectExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;
  Animation<Color> _borderColor;
  Animation<Color> _headerColor;
  Animation<Color> _iconColor;
  Animation<Color> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context)?.readState(context) != null;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openNewProjectPage() {
    mainNavigatorKey.currentState.push<void>(
      MaterialPageRoute<void>(
        builder: (context) => AddProjectScreen(),
      ),
    );
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? Colors.transparent,
        border: Border(
          top: BorderSide(color: borderSideColor),
          bottom: BorderSide(color: borderSideColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            iconColor: _iconColor.value,
            textColor: _headerColor.value,
            child: ListTile(
              dense: true,
              onTap: _handleTap,
              leading: const Icon(Icons.group_work),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Projects'),
                  RotationTransition(
                    turns: _iconTurns,
                    child: const Icon(Icons.expand_more),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _openNewProjectPage,
              ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final theme = Theme.of(context);
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.subhead.color
      ..end = theme.accentColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed
          ? null
          : Column(
              children: widget.projects.items
                  .map<Widget>(
                    (project) => ListTile(
                          dense: true,
                          enabled: widget.selectedProject == null ||
                              widget.selectedProject.id != project.id,
                          selected: widget.selectedProject != null &&
                              widget.selectedProject.id == project.id,
                          leading: Icon(
                            Icons.group_work,
                            color: project.color == null
                                ? null
                                : HexColor(project.color),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth: 200, maxHeight: 40),
                                child: Text(project.title),
                              ),
                              Text(widget.todos.items
                                  .where((todo) =>
                                      todo.project != null &&
                                      todo.project.id == project.id)
                                  .length
                                  .toString()),
                            ],
                          ),
                          onTap: () => widget.onChildSelected(project),
                        ),
                  )
                  .toList()
                    ..add(
                      ListTile(
                        dense: true,
                        title: Text("Manage Projects"),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ManageProjectsScreen()),
                          );
                        },
                      ),
                    ),
            ),
    );
  }
}

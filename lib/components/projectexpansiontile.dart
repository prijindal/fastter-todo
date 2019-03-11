import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../helpers/navigator.dart';
import '../models/base.model.dart';
import '../models/project.model.dart';
import '../store/state.dart';
import '../components/hexcolor.dart';
import '../screens/addproject.dart';

class ProjectExpansionTile extends StatelessWidget {
  final Project selectedProject;
  final void Function(Project) onChildSelected;

  ProjectExpansionTile({
    Key key,
    this.selectedProject,
    @required this.onChildSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _ProjectExpansionTile(
          projects: store.state.projects,
          onChildSelected: onChildSelected,
          selectedProject: selectedProject,
        );
      },
    );
  }
}

class _ProjectExpansionTile extends StatefulWidget {
  final ListState<Project> projects;
  final Project selectedProject;
  final void Function(Project) onChildSelected;

  _ProjectExpansionTile({
    @required this.projects,
    @required this.onChildSelected,
    this.selectedProject,
  });

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
      Tween<double>(begin: 0.0, end: 0.5);

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
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openNewProjectPage() {
    mainNavigatorKey.currentState.push(
      MaterialPageRoute(
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
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

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
              leading: Icon(Icons.group_work),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Projects"),
                  RotationTransition(
                    turns: _iconTurns,
                    child: const Icon(Icons.expand_more),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.add),
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
    final ThemeData theme = Theme.of(context);
    _borderColorTween..end = theme.dividerColor;
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
    final bool closed = !_isExpanded && _controller.isDismissed;
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
                          enabled: widget.selectedProject == null
                              ? true
                              : widget.selectedProject.id != project.id,
                          selected: widget.selectedProject == null
                              ? false
                              : widget.selectedProject.id == project.id,
                          leading: Icon(
                            Icons.group_work,
                            color: project.color == null
                                ? null
                                : HexColor(project.color),
                          ),
                          title: new Text(project.title),
                          onTap: () => widget.onChildSelected(project),
                        ),
                  )
                  .toList(),
            ),
    );
  }
}

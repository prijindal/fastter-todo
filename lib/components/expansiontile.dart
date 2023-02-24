import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fastter/fastter_bloc.dart';
import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../store/todos.dart';

class BaseExpansionTile<T extends BaseModel> extends StatelessWidget {
  const BaseExpansionTile({
    super.key,
    required this.title,
    required this.liststate,
    required this.buildChild,
    required this.manageRoute,
    required this.addRoute,
    required this.icon,
  });

  final String title;
  final Route<void> addRoute;
  final Route<void> manageRoute;
  final ListState<T> liststate;
  final Widget Function(T) buildChild;
  final Icon icon;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterBloc<Todo>, ListState<Todo>>(
        bloc: fastterTodos,
        builder: (context, state) => _BaseExpansionTile<T>(
          addRoute: addRoute,
          manageRoute: manageRoute,
          liststate: liststate,
          title: title,
          icon: icon,
          buildChild: buildChild,
          todos: state.items.where((todo) => todo.completed != true).toList(),
        ),
      );
}

class _BaseExpansionTile<T extends BaseModel> extends StatefulWidget {
  const _BaseExpansionTile({
    required this.title,
    required this.liststate,
    required this.todos,
    required this.addRoute,
    required this.manageRoute,
    required this.buildChild,
    required this.icon,
  });

  final String title;
  final ListState<T> liststate;
  final List<Todo> todos;
  final Route<void> manageRoute;
  final Route<void> addRoute;
  final Widget Function(T) buildChild;
  final Icon icon;

  @override
  _BaseExpansionTileState<T> createState() => _BaseExpansionTileState<T>();
}

class _BaseExpansionTileState<T extends BaseModel>
    extends State<_BaseExpansionTile<T>> with SingleTickerProviderStateMixin {
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

  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this);
  Animation<double>? _iconTurns;
  Animation<double>? _heightFactor;
  Animation<Color?>? _borderColor;
  Animation<Color?>? _headerColor;
  Animation<Color?>? _iconColor;
  Animation<Color?>? _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context).readState(context) != null;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openNewBaseModelPage() {
    Navigator.of(context).push<void>(widget.addRoute);
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
      PageStorage.of(context).writeState(context, _isExpanded);
    });
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final borderSideColor = _borderColor?.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor?.value ?? Colors.transparent,
        border: Border(
          top: BorderSide(color: borderSideColor),
          bottom: BorderSide(color: borderSideColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            iconColor: _iconColor?.value,
            textColor: _headerColor?.value,
            child: ListTile(
              dense: true,
              onTap: _handleTap,
              leading: widget.icon,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.title),
                  if (_iconTurns != null)
                    RotationTransition(
                      turns: _iconTurns!,
                      child: const Icon(Icons.expand_more),
                    ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _openNewBaseModelPage,
              ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor?.value,
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
      ..begin = theme.textTheme.subtitle1?.color
      ..end = theme.colorScheme.secondary;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.colorScheme.secondary;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final closed =
        !_isExpanded && _controller != null && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller,
      builder: _buildChildren,
      child: closed
          ? null
          : Column(
              children:
                  widget.liststate.items.map<Widget>(widget.buildChild).toList()
                    ..add(
                      ListTile(
                        dense: true,
                        title: Text('Manage ${widget.title}'),
                        onTap: () {
                          Navigator.of(context).push(widget.manageRoute);
                        },
                      ),
                    ),
            ),
    );
  }
}

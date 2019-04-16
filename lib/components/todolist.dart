import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/store/state.dart';
import 'package:fastter_dart/store/todos.dart';

import '../components/homeappbar.dart';
import '../components/homeappdrawer.dart';
import '../components/notificationsdrawer.dart';
import '../components/todoinput.dart';
import '../components/todoitem.dart';
import '../helpers/responsive.dart';
import 'todoeditbar.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    this.filter = const <String, dynamic>{},
    this.categoryView = false,
    this.title = 'Todos',
    Key key,
  }) : super(key: key);

  final Map<String, dynamic> filter;
  final bool categoryView;
  final String title;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _TodoList(
              selectedTodos: store.state.selectedTodos,
              projects: store.state.projects,
              categoryView: categoryView,
              todos: ListState<Todo>(
                fetching: store.state.todos.fetching,
                adding: store.state.todos.adding,
                updating: store.state.todos.updating,
                deleting: store.state.todos.deleting,
                items: store.state.todos.items
                    .where((todo) => fastterTodos.filterObject(todo, filter))
                    .toList()
                      ..sort(getCompareFunction(store.state.todos.sortBy)),
                sortBy: store.state.todos.sortBy,
              ),
              filter: filter,
              title: title,
              syncStart: () {
                final action = StartSync<Todo>();
                store.dispatch(action);
                return action.completer;
              },
            ),
      );
}

class _TodoList extends StatefulWidget {
  const _TodoList({
    @required this.todos,
    @required this.projects,
    @required this.syncStart,
    @required this.selectedTodos,
    this.categoryView = false,
    this.filter = const <String, dynamic>{},
    this.title = 'Todos',
    Key key,
  }) : super(key: key);

  final ListState<Todo> todos;
  final ListState<Project> projects;
  final Completer Function() syncStart;
  final bool categoryView;
  final String title;
  final List<String> selectedTodos;
  final Map<String, dynamic> filter;

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<_TodoList> {
  bool _showInput = false;

  List<Widget> _buildBottom() {
    const duration = Duration(milliseconds: 150);
    return [
      Positioned(
        bottom: 0,
        right: 2,
        left: 2,
        child: AnimatedSwitcher(
          duration: duration,
          transitionBuilder: (Widget child, Animation<double> animation) =>
              SizeTransition(child: child, sizeFactor: animation),
          child: widget.selectedTodos.isEmpty && _showInput
              ? TodoInput(
                  project: (widget.filter.containsKey('project') &&
                          widget.projects.items.isNotEmpty)
                      ? widget.projects.items.singleWhere(
                          (project) => project.id == widget.filter['project'],
                          orElse: () => null)
                      : null,
                  onBackButton: () {
                    setState(() {
                      _showInput = false;
                    });
                  },
                )
              : Container(),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 2,
        left: 2,
        child: AnimatedSwitcher(
          duration: duration,
          transitionBuilder: (Widget child, Animation<double> animation) =>
              SizeTransition(child: child, sizeFactor: animation),
          child: widget.selectedTodos.isNotEmpty ? TodoEditBar() : Container(),
        ),
      ),
    ];
  }

  String _dueDateCategorize(DateTime dueDate) {
    if (dueDate == null) {
      return 'No Due Date';
    }
    final now = DateTime.now();
    final diff = dueDate.difference(now);
    if (diff.inDays < 0) {
      return 'Overschedule';
    }
    if (diff.inDays < 7) {
      if (dueDate.day == now.day) {
        return 'Today';
      } else if (dueDate.day == now.day + 1) {
        return 'Tomorrow';
      } else {
        return DateFormat.EEEE().format(dueDate);
      }
    } else if (now.year == dueDate.year) {
      return DateFormat.MMM().format(dueDate);
    }
    return DateFormat.yMMM().format(dueDate);
  }

  Widget _buildPendingTodos() {
    final items = widget.todos.items.toList();
    for (final todo in items) {
      final children = items.where((pTodo) {
        if (pTodo.parent != null) {
          return pTodo.parent.id == todo.id;
        } else {
          return false;
        }
      }).toList();
      todo.children = children;
    }
    if (!widget.categoryView) {
      return Column(
        children: items
            .where((todo) => todo.completed != true && todo.parent == null)
            .map((todo) => TodoItem(
                  todo: todo,
                ))
            .toList(),
      );
    }
    final mapCategoryToList = <String, List<Todo>>{};

    for (final todo in items
        .where((todo) => todo.completed != true && todo.parent == null)) {
      if (widget.todos.sortBy == 'priority') {
        final priorityString = 'Priority ${todo.priority.toString()}';
        if (!mapCategoryToList.containsKey(priorityString)) {
          mapCategoryToList[priorityString] = [];
        }
        mapCategoryToList[priorityString].add(todo);
      } else if (widget.todos.sortBy == 'title') {
        final titleString = '${todo.title[0].toUpperCase().toString()}';
        if (!mapCategoryToList.containsKey(titleString)) {
          mapCategoryToList[titleString] = [];
        }
        mapCategoryToList[titleString].add(todo);
      } else {
        final dueDateString = _dueDateCategorize(todo.dueDate);
        if (!mapCategoryToList.containsKey(dueDateString)) {
          mapCategoryToList[dueDateString] = [];
        }
        mapCategoryToList[dueDateString].add(todo);
      }
    }

    final children = <ExpansionTile>[];

    for (final categoryString in mapCategoryToList.keys) {
      children.add(
        ExpansionTile(
          initiallyExpanded: true,
          title: Text(categoryString),
          children: mapCategoryToList[categoryString]
              .map((todo) => TodoItem(
                    todo: todo,
                  ))
              .toList(),
        ),
      );
    }

    return Column(
      children: children,
    );
  }

  List<Widget> _buildListChildren() {
    if (widget.todos.fetching && widget.todos.items.isEmpty) {
      return [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: const CircularProgressIndicator(),
          ),
        )
      ];
    }
    return widget.todos.items.isEmpty
        ? [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  const Text('No Tasks yet'),
                  RaisedButton(
                    child: const Text('Add a todo'),
                    onPressed: () {
                      setState(() {
                        _showInput = true;
                      });
                    },
                  ),
                ],
              ),
            )
          ]
        : [
            _buildPendingTodos(),
            widget.todos.items
                    .where((todo) => todo.completed == true)
                    .isNotEmpty
                ? ExpansionTile(
                    title: const Text('Completed'),
                    children: widget.todos.items
                        .where((todo) => todo.completed == true)
                        .map((todo) => TodoItem(
                              todo: todo,
                            ))
                        .toList(),
                  )
                : Container(),
          ];
  }

  Widget _buildListView() => CustomScrollView(
        slivers: <Widget>[
          HomeAppBar(
            title: widget.title,
            filter: widget.filter,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              _buildListChildren(),
            ),
          ),
        ],
      );

  Future<void> _onRefresh() {
    final completer = widget.syncStart();
    return completer.future;
  }

  Widget _buildChild() => RefreshIndicator(
        displacement: kToolbarHeight + 40,
        child: Stack(
          children: [
            _buildListView(),
          ]..addAll(_buildBottom()),
        ),
        onRefresh: _onRefresh,
      );

  Widget _buildConnectivity(Widget child, bool connected) => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            padding: EdgeInsets.only(top: connected ? 0 : 24.0),
            child: child,
          ),
          Positioned(
            height: 32,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              color: connected ? Colors.transparent : const Color(0xFFEE4400),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: connected
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text('OFFLINE'),
                          SizedBox(width: 8),
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      );

  Widget _build() {
    if (Platform.isAndroid || Platform.isIOS) {
      return OfflineBuilder(
        connectivityBuilder: (context, connectivity, child) =>
            _buildConnectivity(child, connectivity != ConnectivityResult.none),
        child: _buildChild(),
      );
    }
    return _buildConnectivity(_buildChild(), true);
  }

  Widget _buildPotrait() => Scaffold(
        drawer: const HomeAppDrawer(),
        endDrawer: NotificationsDrawer(),
        floatingActionButton: widget.selectedTodos.isEmpty && !_showInput
            ? FloatingActionButton(
                heroTag: widget.filter.toString(),
                child: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _showInput = true;
                  });
                },
              )
            : null,
        body: _build(),
      );

  Widget _buildLandscape() => Scaffold(
        endDrawer: NotificationsDrawer(),
        floatingActionButton: widget.selectedTodos.isEmpty && !_showInput
            ? FloatingActionButton(
                heroTag: widget.filter.toString(),
                child: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _showInput = true;
                  });
                },
              )
            : null,
        body: Flex(
          direction: Axis.horizontal,
          children: [
            const HomeAppDrawer(),
            Flexible(
              child: _build(),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (getCurrentBreakpoint(context) == ResponsiveBreakpoints.landscape) {
      return _buildLandscape();
    } else {
      return _buildPotrait();
    }
  }
}

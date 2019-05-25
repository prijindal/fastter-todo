import 'dart:async';
import 'package:fastter_dart/store/projects.dart' show fastterProjects;
import 'package:fastter_dart/store/selectedtodos.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
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
      BlocBuilder<FastterEvent<Todo>, ListState<Todo>>(
        bloc: fastterTodos,
        builder: (context, todosState) =>
            BlocBuilder<SelectedTodoEvent, List<String>>(
              bloc: selectedTodosBloc,
              builder: (context, selectedTodos) => _TodoList(
                    selectedTodos: selectedTodos,
                    categoryView: categoryView,
                    todos: todosState.copyWith(
                      items: todosState.items
                          .where((todo) =>
                              todo.parent == null &&
                              fastterTodos.filterObject(todo, filter))
                          .toList()
                            ..sort(getCompareFunction(todosState.sortBy)),
                    ),
                    filter: filter,
                    title: title,
                    syncStart: () {
                      final action = SyncEvent<Todo>();
                      fastterTodos.dispatch(action);
                      return action.completer;
                    },
                  ),
            ),
      );
}

class _TodoList extends StatefulWidget {
  const _TodoList({
    @required this.todos,
    @required this.syncStart,
    @required this.selectedTodos,
    this.categoryView = false,
    this.filter = const <String, dynamic>{},
    this.title = 'Todos',
    Key key,
  }) : super(key: key);

  final ListState<Todo> todos;
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

  List<Widget> _buildBottom() => [
        if (widget.selectedTodos.isEmpty && _showInput)
          Positioned(
            bottom: 0,
            right: 2,
            left: 2,
            child: BlocBuilder<FastterEvent<Project>, ListState<Project>>(
              bloc: fastterProjects,
              builder: (context, projects) => TodoInput(
                    project: (widget.filter.containsKey('project') &&
                            projects.items.isNotEmpty)
                        ? projects.items.singleWhere(
                            (project) => project.id == widget.filter['project'],
                            orElse: () => null)
                        : null,
                    onBackButton: () {
                      setState(() {
                        _showInput = false;
                      });
                    },
                  ),
            ),
          ),
        if (widget.selectedTodos.isNotEmpty)
          Positioned(
            bottom: 0,
            right: 2,
            left: 2,
            child: TodoEditBar(),
          ),
      ];

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

  Map<String, List<Todo>> get _mapCategoryToList {
    final items =
        widget.todos.items.where((todo) => todo.completed != true).toList();
    final sortBy = widget.todos.sortBy;
    final mapCategoryToList = <String, List<Todo>>{};
    for (final todo in items) {
      if (sortBy == 'priority') {
        final priorityString = 'Priority ${todo.priority.toString()}';
        if (!mapCategoryToList.containsKey(priorityString)) {
          mapCategoryToList[priorityString] = [];
        }
        mapCategoryToList[priorityString].add(todo);
      } else if (sortBy == 'title') {
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
    final completedItems =
        widget.todos.items.where((todo) => todo.completed == true).toList();
    if (completedItems.isNotEmpty) {
      mapCategoryToList['Completed'] =
          widget.todos.items.where((todo) => todo.completed == true).toList();
    }
    return mapCategoryToList;
  }

  Widget _renderIthItem(int index) {
    final items =
        widget.todos.items.where((todo) => todo.completed != true).toList();
    if (!widget.categoryView) {
      if (items.isEmpty) {
        return TodoItem(
          todo: widget.todos.items[index],
        );
      }
      return TodoItem(
        todo: items[index],
      );
    }
    final categoryString = _mapCategoryToList.keys.elementAt(index);
    return ListTileTheme.merge(
      key: Key('${categoryString}_listitletheme'),
      dense: true,
      child: ExpansionTile(
        key: Key(categoryString),
        initiallyExpanded: _mapCategoryToList[categoryString]
            .where((todo) => todo.completed != true)
            .isNotEmpty,
        title: Text(
          categoryString,
          style: Theme.of(context).textTheme.body1,
        ),
        children: _mapCategoryToList[categoryString]
            .map(
              (todo) => ListTileTheme.merge(
                  key: Key('${todo.id}_listitletheme'),
                  dense: false,
                  child: TodoItem(
                    todo: todo,
                    key: Key(todo.id),
                  )),
            )
            .toList(),
      ),
    );
  }

  int get _renderItemsCount {
    final items =
        widget.todos.items.where((todo) => todo.completed != true).toList();
    if (!widget.categoryView) {
      if (items.isEmpty) {
        return widget.todos.items.length;
      }
      return items.length;
    }
    return _mapCategoryToList.length;
  }

  Widget _buildListView() {
    if (widget.todos.fetching && widget.todos.items.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return widget.todos.items.isEmpty
        ? Center(
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
        : ListView.builder(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) => _renderIthItem(index),
            itemCount: _renderItemsCount,
          );
  }

  Future<void> _onRefresh() {
    final completer = widget.syncStart();
    return completer.future;
  }

  Widget _build() => RefreshIndicator(
        child: Stack(
          children: [
            _buildListView(),
            ..._buildBottom(),
          ],
        ),
        onRefresh: _onRefresh,
      );

  Widget _buildPotrait() => Scaffold(
        appBar: HomeAppBar(
          title: widget.title,
          filter: widget.filter,
        ),
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
        appBar: HomeAppBar(
          title: widget.title,
          filter: widget.filter,
        ),
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

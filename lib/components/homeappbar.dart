import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../fastter/fastter_action.dart';
import '../helpers/navigator.dart';
import '../helpers/theme.dart';
import '../models/base.model.dart';
import '../models/project.model.dart';
import '../models/todo.model.dart';
import '../screens/editproject.dart';
import '../store/selectedtodos.dart';
import '../store/state.dart';
import '../store/todos.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    @required this.filter,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  });

  final Map<String, dynamic> filter;

  @override
  final Size preferredSize;
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _HomeAppBar(
              selectedtodos: store.state.selectedTodos,
              filter: filter,
              unSelectAll: () {
                store.state.selectedTodos.forEach((todoid) {
                  store.dispatch(UnSelectTodo(todoid));
                });
              },
              projects: store.state.projects,
              deleteSelected: () {
                store.state.selectedTodos.forEach((todoid) {
                  store.dispatch(DeleteItem<Todo>(todoid));
                  store.dispatch(UnSelectTodo(todoid));
                });
              },
              deleteAll: () {
                store.state.todos.items
                    .where((todo) => fastterTodos.filterObject(todo, filter))
                    .toList()
                    .forEach((todo) {
                  store.dispatch(DeleteItem<Todo>(todo.id));
                });
              },
            ),
      );
}

enum _PopupAction { delete, deleteall, editproject }

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({
    @required this.selectedtodos,
    @required this.deleteSelected,
    @required this.unSelectAll,
    @required this.deleteAll,
    @required this.projects,
    @required this.filter,
    Key key,
  }) : super(key: key);

  final Map<String, dynamic> filter;
  final List<String> selectedtodos;
  final VoidCallback deleteSelected;
  final VoidCallback deleteAll;
  final VoidCallback unSelectAll;
  final ListState<Project> projects;

  Project get _project => projects.items.singleWhere(
      (item) => item.id == (filter['project'] as String),
      orElse: () => null);

  Widget _buildTitle() {
    if (selectedtodos.isNotEmpty) {
      return Text(
          '${selectedtodos.length.toString()} Todo${selectedtodos.length > 1 ? 's' : ''} selected');
    }
    String routeName;
    if (history.isNotEmpty) {
      routeName = history.last.routeName;
    } else {
      routeName = '/';
    }
    String title;
    switch (routeName) {
      case '/':
        title = 'Inbox';
        break;
      case '/all':
        title = 'All Todos';
        break;
      case '/today':
        title = 'Today';
        break;
      case '/7days':
        title = '7 Days';
        break;
      case '/todos':
        if (_project != null) {
          title = _project.title;
        } else {
          title = ((history.last.arguments as Map)['project'] as Project).title;
        }
        break;
      default:
        title = 'Todo App';
    }
    return Text(title);
  }

  void _deleteSelected(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Are you sure'),
            content: Text('This will delete ${selectedtodos.length} tasks'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteSelected();
                },
              ),
            ],
          ),
    );
  }

  void _deleteAll(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Are you sure'),
            content: const Text('This will delete all tasks'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteAll();
                },
              ),
            ],
          ),
    );
  }

  void _editProject(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => EditProjectScreen(
              project: _project,
            ),
      ),
    );
  }

  Widget _buildPopupAction(BuildContext context) =>
      PopupMenuButton<_PopupAction>(
          onSelected: (value) {
            if (selectedtodos.isNotEmpty) {
              if (value == _PopupAction.delete) {
                _deleteSelected(context);
              }
            } else {
              if (value == _PopupAction.deleteall) {
                _deleteAll(context);
              } else if (value == _PopupAction.editproject) {
                _editProject(context);
              }
            }
          },
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) {
            if (selectedtodos.isNotEmpty) {
              return [
                PopupMenuItem<_PopupAction>(
                  child: const Text('Delete'),
                  value: _PopupAction.delete,
                )
              ];
            } else {
              List<PopupMenuItem<_PopupAction>> items = [];
              if (_project != null) {
                items.add(PopupMenuItem<_PopupAction>(
                  child: const Text('Edit Project'),
                  value: _PopupAction.editproject,
                ));
              }
              items.add(PopupMenuItem<_PopupAction>(
                child: const Text('Delete All'),
                value: _PopupAction.deleteall,
              ));
              return items;
            }
          });

  @override
  Widget build(BuildContext context) => AnimatedTheme(
        data: selectedtodos.isNotEmpty ? whiteTheme : primaryTheme,
        child: AppBar(
          leading: selectedtodos.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: unSelectAll,
                )
              : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    homeScaffoldKey.currentState.openDrawer();
                  },
                ),
          title: _buildTitle(),
          actions: [
            _buildPopupAction(context),
          ],
        ),
      );
}

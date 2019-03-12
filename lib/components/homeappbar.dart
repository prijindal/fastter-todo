import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../fastter/fastter_action.dart';
import '../helpers/navigator.dart';
import '../helpers/theme.dart';
import '../models/project.model.dart';
import '../models/todo.model.dart';
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
              unSelectAll: () {
                store.state.selectedTodos.forEach((todoid) {
                  store.dispatch(UnSelectTodo(todoid));
                });
              },
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

enum _PopupAction { delete, deleteall }

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({
    @required this.selectedtodos,
    @required this.deleteSelected,
    @required this.unSelectAll,
    @required this.deleteAll,
    Key key,
  }) : super(key: key);

  final List<String> selectedtodos;
  final VoidCallback deleteSelected;
  final VoidCallback deleteAll;
  final VoidCallback unSelectAll;

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
        title = ((history.last.arguments as Map)['project'] as Project).title;
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
            PopupMenuButton<_PopupAction>(
              onSelected: (value) {
                if (selectedtodos.isNotEmpty) {
                  if (value == _PopupAction.delete) {
                    _deleteSelected(context);
                  }
                } else {
                  if (value == _PopupAction.deleteall) {
                    _deleteAll(context);
                  }
                }
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => selectedtodos.isNotEmpty
                  ? [
                      PopupMenuItem<_PopupAction>(
                        child: const Text('Delete'),
                        value: _PopupAction.delete,
                      )
                    ]
                  : [
                      PopupMenuItem<_PopupAction>(
                        child: const Text('Delete All'),
                        value: _PopupAction.deleteall,
                      )
                    ],
            )
          ],
        ),
      );
}

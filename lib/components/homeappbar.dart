import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/todo.model.dart';
import '../models/project.model.dart';
import '../fastter/fastter_action.dart';
import '../store/state.dart';
import '../store/todos.dart';
import '../store/selectedtodos.dart';
import '../helpers/theme.dart';
import '../helpers/navigator.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> filter;

  @override
  final Size preferredSize;

  HomeAppBar({
    @required this.filter,
  }) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _HomeAppBar(
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
        );
      },
    );
  }
}

enum _PopupAction { delete, deleteall }

class _HomeAppBar extends StatelessWidget {
  final List<String> selectedtodos;
  final VoidCallback deleteSelected;
  final VoidCallback deleteAll;
  final VoidCallback unSelectAll;

  _HomeAppBar({
    Key key,
    @required this.selectedtodos,
    @required this.deleteSelected,
    @required this.unSelectAll,
    @required this.deleteAll,
  }) : super(key: key);

  Widget _buildTitle() {
    if (selectedtodos.length > 0) {
      return new Text(
          "${selectedtodos.length.toString()} Todo${selectedtodos.length > 1 ? 's' : ''} selected");
    }
    String routeName;
    if (history.isNotEmpty) {
      routeName = history.last.routeName;
    } else {
      routeName = "/";
    }
    String title;
    switch (routeName) {
      case "/":
        title = "Inbox";
        break;
      case "/all":
        title = "All Todos";
        break;
      case "/today":
        title = "Today";
        break;
      case "/7days":
        title = "7 Days";
        break;
      case "/todos":
        title = ((history.last.arguments as Map)['project'] as Project).title;
        break;
      default:
        title = "Todo App";
    }
    return Text(title);
  }

  void _deleteSelected(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Are you sure"),
            content: Text("This will delete ${selectedtodos.length} tasks"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text("Yes"),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Are you sure"),
            content: Text("This will delete all tasks"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text("Yes"),
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
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: selectedtodos.length > 0 ? whiteTheme : primaryTheme,
      child: AppBar(
        leading: selectedtodos.length > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  unSelectAll();
                },
              )
            : IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  homeScaffoldKey.currentState.openDrawer();
                },
              ),
        title: _buildTitle(),
        actions: [
          PopupMenuButton<_PopupAction>(
            onSelected: (_PopupAction value) {
              if (selectedtodos.length > 0) {
                if (value == _PopupAction.delete) {
                  _deleteSelected(context);
                }
              } else {
                if (value == _PopupAction.deleteall) {
                  _deleteAll(context);
                }
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => selectedtodos.length > 0
                ? [
                    PopupMenuItem<_PopupAction>(
                      child: Text("Delete"),
                      value: _PopupAction.delete,
                    )
                  ]
                : [
                    PopupMenuItem<_PopupAction>(
                      child: Text("Delete All"),
                      value: _PopupAction.deleteall,
                    )
                  ],
          )
        ],
      ),
    );
  }
}

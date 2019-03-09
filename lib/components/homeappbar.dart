import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/todo.model.dart';
import '../models/project.model.dart';
import '../fastter/fastter_action.dart';
import '../store/state.dart';
import '../store/user.dart';
import '../store/selectedtodos.dart';
import '../helpers/theme.dart';
import '../helpers/navigator.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  HomeAppBar() : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _HomeAppBar(
            onLogout: () => store.dispatch(LogoutUserAction()),
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
            });
      },
    );
  }
}

enum _PopupAction { delete }

class _HomeAppBar extends StatelessWidget {
  final void Function() onLogout;
  final List<String> selectedtodos;
  final VoidCallback deleteSelected;
  final VoidCallback unSelectAll;

  _HomeAppBar({
    Key key,
    @required this.onLogout,
    @required this.selectedtodos,
    @required this.deleteSelected,
    @required this.unSelectAll,
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
            : null,
        title: _buildTitle(),
        actions: selectedtodos.length > 0
            ? <Widget>[
                PopupMenuButton<_PopupAction>(
                  onSelected: (_PopupAction value) {
                    if (value == _PopupAction.delete) {
                      deleteSelected();
                    }
                  },
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                        PopupMenuItem<_PopupAction>(
                          child: Text("Delete"),
                          value: _PopupAction.delete,
                        )
                      ],
                )
              ]
            : [
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: onLogout,
                ),
              ],
      ),
    );
  }
}

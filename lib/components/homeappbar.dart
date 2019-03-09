import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/todo.model.dart';
import '../fastter/fastter_action.dart';
import '../store/state.dart';
import '../store/user.dart';
import '../store/selectedtodos.dart';
import '../helpers/theme.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;

  HomeAppBar({
    this.title = "Todo App",
  }) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _HomeAppBar(
            onLogout: () => store.dispatch(LogoutUserAction()),
            title: title,
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
  final String title;
  final List<String> selectedtodos;
  final VoidCallback deleteSelected;
  final VoidCallback unSelectAll;

  _HomeAppBar({
    Key key,
    @required this.onLogout,
    @required this.selectedtodos,
    @required this.deleteSelected,
    @required this.unSelectAll,
    this.title = "Todo App",
  }) : super(key: key);

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
        title: selectedtodos.length > 0
            ? new Text(
                "${selectedtodos.length.toString()} Todo${selectedtodos.length > 1 ? 's' : ''} selected")
            : new Text(title),
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

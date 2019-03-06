import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../store/state.dart';
import '../store/currentuser.dart';

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
        );
      },
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  final void Function() onLogout;
  _HomeAppBar({Key key, this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: new Text("Todo App"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: onLogout,
        )
      ],
    );
  }
}

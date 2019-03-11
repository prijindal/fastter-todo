import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/user.model.dart';
import '../store/user.dart';
import '../store/state.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _SettingsScreen(
          user: store.state.user,
          onLogout: () => store.dispatch(LogoutUserAction()),
        );
      },
    );
  }
}

class _SettingsScreen extends StatelessWidget {
  final void Function() onLogout;
  final UserState user;
  _SettingsScreen({@required this.onLogout, @required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Account"),
            onTap: () => Navigator.of(context).pushNamed('/settings/account'),
          ),
          AboutListTile(
            icon: const Icon(Icons.info),
            applicationName: "Fastter Todo App",
            applicationVersion: "0.0.1",
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            subtitle: Text(user.user.email),
            onTap: onLogout,
          )
        ],
      ),
    );
  }
}

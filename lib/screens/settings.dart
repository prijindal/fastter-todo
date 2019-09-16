import 'package:fastter_todo/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fastter_dart/models/user.model.dart';
import 'package:fastter_dart/store/user.dart';
import 'package:fastter_todo/screens/loading.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
        bloc: fastterUser,
        builder: (context, state) => state != null && state.user != null
            ? _SettingsScreen(
                user: state,
                onLogout: () => fastterUser.dispatch(LogoutUserEvent()),
              )
            : LoadingScreen(),
      );
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen({
    @required this.onLogout,
    @required this.user,
  });

  final void Function() onLogout;
  final UserState user;

  Future<void> _onLogout(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Logout?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop<bool>(false),
                  child: const Text('No'),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop<bool>(true),
                  child: const Text('Yes'),
                )
              ],
            ));
    if (shouldDelete) {
      onLogout();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('General'),
              onTap: () => Navigator.of(context).pushNamed('/settings/general'),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account'),
              onTap: () => Navigator.of(context).pushNamed('/settings/account'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => Navigator.of(context).pushNamed('/about'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Privacy Policy'),
              onTap: () => Navigator.of(context).pushNamed('/privacypolicy'),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              subtitle: Text(user.user.email),
              onTap: () => _onLogout(context),
            )
          ],
        ),
      );
}

import 'package:fastter_todo/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/user.model.dart';
import '../store/user.dart';
import 'package:fastter_todo/screens/loading.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _SettingsScreen(
        onLogout: () => fastterUser.add(LogoutUserEvent()),
      );
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen({
    required this.onLogout,
  });

  final void Function() onLogout;

  Future<void> _onLogout(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Logout?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop<bool>(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop<bool>(true),
                  child: const Text('Yes'),
                )
              ],
            ));
    if (shouldDelete != null && shouldDelete) {
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
              onTap: () => launchUrlString(
                  'https://fastter-todo.web.app/privacy-policy.html'),
            ),
            BlocBuilder<UserBloc, UserState>(
              bloc: fastterUser,
              builder: (context, state) => state != null && state.user != null
                  ? ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text('Logout'),
                      onTap: () => _onLogout(context),
                    )
                  : Container(),
            )
          ],
        ),
      );
}

import '../models/user.model.dart';
import 'package:fastter_todo/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/settings.model.dart';
import '../store/user.dart';

class GeneralSettingsScreen extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
        bloc: fastterUser,
        builder: (context, userState) => _GeneralSettingsScreen(
          settings: userState.user?.settings,
          updateSettings: (settings) {
            fastterUser.add(UpdateUserEvent(settings: settings));
          },
        ),
      );
}

class _GeneralSettingsScreen extends StatelessWidget {
  const _GeneralSettingsScreen({
    required this.settings,
    required this.updateSettings,
  });

  final UserSettings? settings;
  final void Function(UserSettings) updateSettings;

  Future<void> _editFrontPage(BuildContext context) async {
    final frontpages = <FrontPage>[
      FrontPage(route: '/', title: 'Inbox'),
      FrontPage(route: '/all', title: 'All'),
      FrontPage(route: '/today', title: 'Today'),
      FrontPage(route: '/7days', title: '7 Days'),
    ];
    final newFrontPage = await showDialog<FrontPage>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select front page'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: frontpages
              .map((fpage) => ListTile(
                    title: Text(fpage.title ?? "Todos"),
                    onTap: () => Navigator.of(context).pop<FrontPage>(fpage),
                  ))
              .toList(),
        ),
      ),
    );
    if (newFrontPage != null && settings != null) {
      updateSettings(UserSettings(
        frontPage: newFrontPage,
        notifications: settings!.notifications,
      ));
    }
  }

  void _toggleNotification(bool newValue) {
    if (settings != null) {
      updateSettings(UserSettings(
        frontPage: settings!.frontPage,
        notifications: UserNotifiationsSettings(
          enable: newValue,
        ),
      ));
    }
  }

  FrontPage get _frontPage =>
      settings?.frontPage ??
      FrontPage(
        title: 'Inbox',
        route: '/',
      );

  UserNotifiationsSettings get _notifications =>
      settings?.notifications ??
      UserNotifiationsSettings(
        enable: false,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('General Settings'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Front Page'),
              subtitle: Text(_frontPage.title ?? _frontPage.route),
              onTap: () => _editFrontPage(context),
            ),
            SwitchListTile(
              title: const Text('Notifications'),
              value: _notifications.enable,
              onChanged: _toggleNotification,
            ),
          ],
        ),
      );
}

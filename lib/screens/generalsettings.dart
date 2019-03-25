import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/models/settings.model.dart';
import 'package:fastter_dart/store/state.dart';
import 'package:fastter_dart/store/user.dart';

class GeneralSettingsScreen extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _GeneralSettingsScreen(
              settings: store.state.user.user.settings ??
                  UserSettings(), // TODO(prijindal): Get it from store
              updateSettings: (UserSettings settings) {
                store.dispatch(UpdateUserAction(settings: settings));
              },
            ),
      );
}

class _GeneralSettingsScreen extends StatefulWidget {
  const _GeneralSettingsScreen({
    @required this.settings,
    @required this.updateSettings,
  });

  final UserSettings settings;
  final void Function(UserSettings) updateSettings;

  @override
  _GeneralSettingsScreenState createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<_GeneralSettingsScreen> {
  FrontPage frontPage;

  @override
  void initState() {
    setState(() {
      if (widget.settings.frontPage == null) {
        frontPage = FrontPage(
          title: 'Inbox',
          route: '/',
        );
      } else {
        frontPage = widget.settings.frontPage;
      }
    });
    super.initState();
  }

  Future<void> _editFrontPage() async {
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
                        title: Text(fpage.title),
                        onTap: () =>
                            Navigator.of(context).pop<FrontPage>(fpage),
                      ))
                  .toList(),
            ),
          ),
    );
    if (newFrontPage != null) {
      setState(() {
        frontPage = newFrontPage;
      });
      widget.updateSettings(UserSettings(frontPage: newFrontPage));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('General Settings'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Front Page'),
              subtitle: Text(frontPage.title ?? frontPage.route),
              onTap: _editFrontPage,
            )
          ],
        ),
      );
}

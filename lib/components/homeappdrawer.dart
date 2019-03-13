import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../helpers/navigator.dart';
import '../models/base.model.dart';
import '../models/project.model.dart';
import '../models/user.model.dart';
import '../screens/loading.dart';
import '../store/state.dart';

import 'projectexpansiontile.dart';

class HomeAppDrawer extends StatelessWidget {
  const HomeAppDrawer({Key key, this.disablePop = false}) : super(key: key);

  final bool disablePop;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _HomeAppDrawer(
              user: store.state.user,
              projects: store.state.projects,
              disablePop: disablePop,
            ),
      );
}

class _HomeAppDrawer extends StatelessWidget {
  const _HomeAppDrawer({
    @required this.user,
    @required this.projects,
    this.disablePop = false,
    Key key,
  }) : super(key: key);

  final UserState user;
  final ListState<Project> projects;
  final bool disablePop;

  void _pushRouteNamed(
    BuildContext context,
    String routeName, {
    Object arguments,
  }) {
    navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
    history.add(RouteInfo(routeName, arguments: arguments));
    if (!disablePop) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (navigatorKey == null) {
      return LoadingScreen();
    }
    String routeName;
    if (history.isNotEmpty) {
      routeName = history.last.routeName;
    } else {
      routeName = '/';
    }
    return Drawer(
      child: ListView(
        children: <Widget>[
          user != null && user.user != null
              ? ListTile(
                  onTap: () =>
                      Navigator.of(context).pushNamed('/settings/account'),
                  leading:
                      user.user.picture == null || user.user.picture.isEmpty
                          ? const Icon(
                              Icons.person,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                user.user.picture,
                              ),
                            ),
                  title: Text(user.user.name),
                  subtitle: Text(user.user.email),
                )
              : Container(),
          ListTile(
            dense: true,
            enabled: routeName != '/',
            selected: routeName == '/',
            leading: const Icon(Icons.inbox),
            title: const Text('Inbox'),
            onTap: () {
              _pushRouteNamed(context, '/');
            },
          ),
          ListTile(
            dense: true,
            enabled: routeName != '/all',
            selected: routeName == '/all',
            leading: const Icon(Icons.select_all),
            title: const Text('All Todos'),
            onTap: () {
              _pushRouteNamed(context, '/all');
            },
          ),
          ListTile(
            dense: true,
            enabled: routeName != '/today',
            selected: routeName == '/today',
            leading: const Icon(Icons.calendar_today),
            title: const Text('Today'),
            onTap: () {
              _pushRouteNamed(context, '/today');
            },
          ),
          ListTile(
            dense: true,
            enabled: routeName != '/7days',
            selected: routeName == '/7days',
            leading: const Icon(Icons.calendar_view_day),
            title: const Text('7 Days'),
            onTap: () {
              _pushRouteNamed(context, '/7days');
            },
          ),
          ProjectExpansionTile(
            selectedProject: routeName == '/todos'
                ? ((history.last.arguments as Map)['project'] as Project)
                : null,
            onChildSelected: (project) {
              _pushRouteNamed(context, '/todos',
                  arguments: {'project': project});
            },
          ),
          ListTile(
            dense: true,
            title: const Text('Settings'),
            onTap: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
    );
  }
}

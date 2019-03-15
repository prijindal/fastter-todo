import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../helpers/navigator.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/user.model.dart';
import '../screens/loading.dart';
import 'package:fastter_dart/store/state.dart';

import 'labelexpansiontile.dart';
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
              todos: ListState<Todo>(
                items: store.state.todos.items
                    .where((todo) => todo.completed != true)
                    .toList(),
              ),
              disablePop: disablePop,
            ),
      );
}

class _HomeAppDrawer extends StatelessWidget {
  const _HomeAppDrawer({
    @required this.user,
    @required this.projects,
    @required this.todos,
    this.disablePop = false,
    Key key,
  }) : super(key: key);

  final UserState user;
  final ListState<Project> projects;
  final ListState<Todo> todos;
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Inbox'),
                Text(todos.items
                    .where((todo) => todo.project == null)
                    .length
                    .toString()),
              ],
            ),
            onTap: () {
              _pushRouteNamed(context, '/');
            },
          ),
          ListTile(
            dense: true,
            enabled: routeName != '/all',
            selected: routeName == '/all',
            leading: const Icon(Icons.select_all),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('All Tasks'),
                Text(todos.items.length.toString()),
              ],
            ),
            onTap: () {
              _pushRouteNamed(context, '/all');
            },
          ),
          ListTile(
            dense: true,
            enabled: routeName != '/today',
            selected: routeName == '/today',
            leading: const Icon(Icons.calendar_today),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Today'),
                Text(todos.items
                    .where((todo) =>
                        todo.dueDate != null &&
                        todo.dueDate.difference(DateTime.now()).inDays >= 0 &&
                        todo.dueDate.day == DateTime.now().day)
                    .length
                    .toString()),
              ],
            ),
            onTap: () {
              _pushRouteNamed(context, '/today');
            },
          ),
          ListTile(
            dense: true,
            enabled: routeName != '/7days',
            selected: routeName == '/7days',
            leading: const Icon(Icons.calendar_view_day),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('7 Days'),
                Text(todos.items
                    .where((todo) =>
                        todo.dueDate != null &&
                        todo.dueDate.difference(DateTime.now()).inDays >= 0 &&
                        todo.dueDate.difference(DateTime.now()).inDays < 7)
                    .length
                    .toString()),
              ],
            ),
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
          LabelExpansionTile(
            selectedLabel: routeName == '/todos'
                ? ((history.last.arguments as Map)['label'] as Label)
                : null,
            onChildSelected: (label) {
              _pushRouteNamed(context, '/todos', arguments: {'label': label});
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

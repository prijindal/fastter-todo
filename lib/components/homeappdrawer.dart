import 'package:fastter_dart/store/projects.dart';
import 'package:fastter_dart/store/todos.dart';
import 'package:fastter_dart/store/user.dart';
import 'package:fastter_todo/bloc.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/user.model.dart';
import 'package:fastter_dart/models/settings.model.dart';

import '../helpers/navigator.dart';
import '../helpers/todofilters.dart';

import 'labelexpansiontile.dart';
import 'projectexpansiontile.dart';

class HomeAppDrawer extends StatelessWidget {
  const HomeAppDrawer({Key key, this.disablePop = false}) : super(key: key);

  final bool disablePop;

  @override
  Widget build(BuildContext context) => BlocBuilder<UserEvent, UserState>(
        bloc: fastterUser,
        builder: (context, userState) => _HomeAppDrawer(
              user: userState,
              projects: fastterProjects.currentState,
              todos: ListState<Todo>(
                items: fastterTodos.currentState.items
                    .where((todo) => todo.completed != true)
                    .toList(),
              ),
              disablePop: disablePop,
              frontPage: userState.user?.settings?.frontPage ??
                  FrontPage(
                    route: '/',
                    title: 'Inbox',
                  ),
            ),
      );
}

class _HomeAppDrawer extends StatelessWidget {
  const _HomeAppDrawer({
    @required this.user,
    @required this.projects,
    @required this.todos,
    @required this.frontPage,
    this.disablePop = false,
    Key key,
  }) : super(key: key);

  final UserState user;
  final ListState<Project> projects;
  final ListState<Todo> todos;
  final bool disablePop;
  final FrontPage frontPage;

  static DateTime now = DateTime.now();
  static DateTime startOfToday =
      DateTime(now.year, now.month, now.day, 0, 0, 0, 0);

  void _pushRouteNamed(
    BuildContext context,
    String routeName, {
    Object arguments,
  }) {
    if (!disablePop) {
      Navigator.pop(context);
    }
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
    history.add(RouteInfo(routeName, arguments: arguments));
  }

  String get routeName =>
      history.isNotEmpty ? history.last.routeName : frontPage.route;

  Project get _project {
    if (routeName == '/todos') {
      final Map map = history.last.arguments;
      final Project project = map['project'];
      return project;
    } else {
      return null;
    }
  }

  Label get _label {
    if (routeName == '/todos') {
      final Map map = history.last.arguments;
      final Label label = map['label'];
      return label;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          children: <Widget>[
            if (user != null && user.user != null)
              ListTile(
                onTap: () =>
                    Navigator.of(context).pushNamed('/settings/account'),
                leading: user.user.picture == null || user.user.picture.isEmpty
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
              ),
            ListTile(
              dense: true,
              enabled: routeName != '/',
              selected: routeName == '/',
              leading: const Icon(Icons.inbox),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Inbox'),
                  Text(filterToCount(<String, dynamic>{'project': null}, todos)
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
                  Text(filterToCount(<String, dynamic>{}, todos).toString()),
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
                  Text(filterToCount(
                    <String, dynamic>{
                      '_operators': {
                        'dueDate': {
                          'lte': startOfToday.add(const Duration(days: 1)),
                        },
                      },
                    },
                    todos,
                  ).toString()),
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
                  Text(filterToCount(
                    <String, dynamic>{
                      '_operators': {
                        'dueDate': {
                          'lte': startOfToday.add(const Duration(days: 7)),
                        },
                      },
                    },
                    todos,
                  ).toString()),
                ],
              ),
              onTap: () {
                _pushRouteNamed(context, '/7days');
              },
            ),
            ProjectExpansionTile(
              selectedProject: _project,
              onChildSelected: (project) {
                _pushRouteNamed(context, '/todos',
                    arguments: {'project': project});
              },
            ),
            LabelExpansionTile(
              selectedLabel: _label,
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

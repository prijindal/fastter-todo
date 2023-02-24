import 'package:fastter_todo/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helpers/navigator.dart';
import '../models/label.model.dart';
import '../models/project.model.dart';
import '../models/settings.model.dart';
import '../models/user.model.dart';
import '../store/user.dart';

import 'filtercountext.dart';
import 'labelexpansiontile.dart';
import 'projectexpansiontile.dart';

class HomeAppDrawer extends StatelessWidget {
  const HomeAppDrawer({super.key, this.disablePop = false});

  final bool disablePop;

  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
        bloc: fastterUser,
        builder: (context, userState) => _HomeAppDrawer(
          user: userState,
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
    required this.user,
    required this.frontPage,
    this.disablePop = false,
  });

  final UserState user;
  final bool disablePop;
  final FrontPage frontPage;

  static DateTime now = DateTime.now();
  static DateTime startOfToday =
      DateTime(now.year, now.month, now.day, 0, 0, 0, 0);

  void _pushRouteNamed(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    if (!disablePop) {
      Navigator.pop(context);
    }
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
    history.add(RouteInfo(routeName, arguments: arguments));
  }

  String get routeName =>
      history.isNotEmpty ? history.last.routeName : frontPage.route;

  Project? get _project {
    if (routeName == '/todos') {
      final Map<String, dynamic>? map = history.last.arguments;
      final project = map?['project'];
      if (project is Project) {
        return project;
      }
    }
    return null;
  }

  Label? get _label {
    if (routeName == '/todos') {
      final Map<String, dynamic>? map = history.last.arguments;
      final label = map?['label'];
      if (label is Label) {
        return label;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          children: <Widget>[
            if (user != null && user.user != null)
              ListTile(
                onTap: () =>
                    Navigator.of(context).pushNamed('/settings/account'),
                leading:
                    user.user?.picture == null || user.user!.picture!.isEmpty
                        ? const Icon(
                            Icons.person,
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.user!.picture!,
                            ),
                          ),
                title: Text(user.user?.name ?? ""),
                subtitle: Text(user.user?.email ?? ""),
              ),
            ListTile(
              dense: true,
              enabled: routeName != '/',
              selected: routeName == '/',
              leading: const Icon(Icons.inbox),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Inbox'),
                  FilterCountText(<String, dynamic>{'project': null}),
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
                children: const [
                  Text('All Tasks'),
                  FilterCountText(<String, dynamic>{}),
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
                  FilterCountText(
                    <String, dynamic>{
                      '_operators': {
                        'dueDate': {
                          'lte': startOfToday.add(const Duration(days: 1)),
                        },
                      },
                    },
                  ),
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
                  FilterCountText(
                    <String, dynamic>{
                      '_operators': {
                        'dueDate': {
                          'lte': startOfToday.add(const Duration(days: 7)),
                        },
                      },
                    },
                  ),
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

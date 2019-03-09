import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/base.model.dart';
import '../models/user.model.dart';
import '../models/project.model.dart';
import '../fastter/fastter_action.dart';
import '../screens/loading.dart';
import '../store/state.dart';
import '../helpers/navigator.dart';
import 'projectexpansiontile.dart';

class HomeAppDrawer extends StatelessWidget {
  final bool disablePop;
  HomeAppDrawer({Key key, this.disablePop = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _HomeAppDrawer(
          user: store.state.user,
          projects: store.state.projects,
          syncStart: () => store.dispatch(StartSync<Project>()),
          disablePop: disablePop,
        );
      },
    );
  }
}

class _HomeAppDrawer extends StatefulWidget {
  final UserState user;
  final ListState<Project> projects;
  final VoidCallback syncStart;
  final bool disablePop;

  _HomeAppDrawer({
    Key key,
    @required this.user,
    @required this.projects,
    @required this.syncStart,
    this.disablePop = false,
  }) : super(key: key);

  __HomeAppDrawerState createState() => __HomeAppDrawerState();
}

class __HomeAppDrawerState extends State<_HomeAppDrawer> {
  @override
  void initState() {
    widget.syncStart();
    super.initState();
  }

  void _pushRouteNamed(
    String routeName, {
    Object arguments,
  }) {
    navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
    history.add(RouteInfo(routeName, arguments: arguments));
    if (!widget.disablePop) {
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
      routeName = "/";
    }
    return Drawer(
      child: ListView(
        children: <Widget>[
          widget.user != null && widget.user.user != null
              ? UserAccountsDrawerHeader(
                  currentAccountPicture: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  accountName: Text(widget.user.user.email),
                  accountEmail: Text(widget.user.user.email),
                )
              : Container(),
          ListTile(
            dense: true,
            selected: routeName == "/",
            leading: Icon(Icons.inbox),
            title: Text("Inbox"),
            onTap: () {
              _pushRouteNamed("/");
            },
          ),
          ListTile(
            dense: true,
            selected: routeName == "/all",
            leading: Icon(Icons.select_all),
            title: Text("All Todos"),
            onTap: () {
              _pushRouteNamed("/all");
            },
          ),
          ListTile(
            dense: true,
            selected: routeName == "/today",
            leading: Icon(Icons.calendar_today),
            title: Text("Today"),
            onTap: () {
              _pushRouteNamed("/today");
            },
          ),
          ListTile(
            dense: true,
            selected: routeName == "/7days",
            leading: Icon(Icons.calendar_view_day),
            title: Text("7 Days"),
            onTap: () {
              _pushRouteNamed("/7days");
            },
          ),
          ProjectExpansionTile(
            selectedProject: routeName == "/todos"
                ? ((history.last.arguments as Map)['project'] as Project)
                : null,
            onChildSelected: (project) {
              _pushRouteNamed("/todos", arguments: {'project': project});
            },
          ),
          AboutListTile(
            icon: const Icon(Icons.info),
            applicationName: "Fastter Todo App",
            applicationVersion: "0.0.1",
          )
        ],
      ),
    );
  }
}

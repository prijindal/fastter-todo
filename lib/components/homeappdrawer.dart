import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/base.model.dart';
import '../models/user.model.dart';
import '../models/project.model.dart';
import '../fastter/fastter_action.dart';
import '../screens/loading.dart';
import '../store/state.dart';
import '../components/hexcolor.dart';
import '../helpers/navigator.dart';

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
    print(navigatorKey.currentContext);
    if (!widget.disablePop) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (navigatorKey == null) {
      return LoadingScreen();
    }
    final RouteSettings currentRoute =
        ModalRoute.of(navigatorKey.currentContext).settings;
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
            selected: currentRoute.name == "/",
            leading: Icon(Icons.inbox),
            title: Text("Inbox"),
            onTap: () {
              _pushRouteNamed("/");
            },
          ),
          ListTile(
            selected: currentRoute.name == "/all",
            leading: Icon(Icons.select_all),
            title: Text("All Todos"),
            onTap: () {
              _pushRouteNamed("/all");
            },
          ),
          ListTile(
            selected: currentRoute.name == "/today",
            leading: Icon(Icons.calendar_today),
            title: Text("Today"),
            onTap: () {
              _pushRouteNamed("/today");
            },
          ),
          ListTile(
            selected: currentRoute.name == "/7days",
            leading: Icon(Icons.calendar_view_day),
            title: Text("7 Days"),
            onTap: () {
              _pushRouteNamed("/7days");
            },
          ),
          Column(
            children: widget.projects.items
                .map<Widget>(
                  (project) => ListTile(
                        selected: currentRoute.name == "/todos",
                        leading: Icon(
                          Icons.group_work,
                          color: HexColor(project.color),
                        ),
                        title: new Text(project.title),
                        onTap: () {
                          _pushRouteNamed("/todos",
                              arguments: {'project': project});
                        },
                      ),
                )
                .toList(),
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

import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/base.model.dart';
import '../models/user.model.dart';
import '../models/project.model.dart';
import '../store/fastter_action.dart';
import '../store/state.dart';

class HomeAppDrawer extends StatelessWidget {
  HomeAppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _HomeAppDrawer(
          user: store.state.user,
          projects: store.state.projects,
          syncStart: () => store.dispatch(StartSync<Project>()),
        );
      },
    );
  }
}

class _HomeAppDrawer extends StatefulWidget {
  final User user;
  final ListState<Project> projects;
  final VoidCallback syncStart;

  _HomeAppDrawer({
    Key key,
    @required this.user,
    @required this.projects,
    @required this.syncStart,
  }) : super(key: key);

  __HomeAppDrawerState createState() => __HomeAppDrawerState();
}

class __HomeAppDrawerState extends State<_HomeAppDrawer> {
  @override
  void initState() {
    widget.syncStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: Icon(
              Icons.person,
              color: Colors.white,
            ),
            accountName: Text(widget.user.email),
            accountEmail: Text(widget.user.email),
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text("Inbox"),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Today"),
          ),
          ListTile(
            leading: Icon(Icons.calendar_view_day),
            title: Text("7 Days"),
          ),
          Column(
            children: widget.projects.items
                .map<Widget>(
                  (project) => ListTile(
                        leading: Icon(
                          Icons.tonality,
                          color: Colors.red,
                        ),
                        title: new Text(project.title),
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

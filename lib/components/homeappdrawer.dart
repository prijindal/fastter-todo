import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/base.model.dart';
import '../models/user.model.dart';
import '../models/project.model.dart';
import '../fastter/fastter_action.dart';
import '../store/state.dart';
import '../components/hexcolor.dart';

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
    final RouteSettings currentRoute = ModalRoute.of(context).settings;
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
            selected: currentRoute.name == "/",
            leading: Icon(Icons.inbox),
            title: Text("Inbox"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          ListTile(
            selected: currentRoute.name == "/all",
            leading: Icon(Icons.select_all),
            title: Text("All Todos"),
            onTap: () {
              Navigator.of(context).pushNamed("/all");
            },
          ),
          ListTile(
            selected: currentRoute.name == "/today",
            leading: Icon(Icons.calendar_today),
            title: Text("Today"),
            onTap: () {
              Navigator.of(context).pushNamed("/today");
            },
          ),
          ListTile(
            selected: currentRoute.name == "/7days",
            leading: Icon(Icons.calendar_view_day),
            title: Text("7 Days"),
            onTap: () {
              Navigator.of(context).pushNamed("/7days");
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
                          Navigator.of(context).pushNamed("/todos",
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

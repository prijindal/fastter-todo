import 'dart:math';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/todo.model.dart';
import '../models/project.model.dart';
import '../components/todolist.dart';
import '../screens/todos.dart';
import '../components/homeappdrawer.dart';
import '../helpers/navigator.dart';
import '../store/state.dart';
import '../screens/settings.dart';
import '../screens/profile.dart';
import '../helpers/theme.dart';
import '../fastter/fastter_action.dart';

class HomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _HomeContainer(
          projectSyncStart: () => store.dispatch(StartSync<Project>()),
          todoSyncStart: () => store.dispatch(StartSync<Todo>()),
        );
      },
    );
  }
}

class _HomeContainer extends StatelessWidget {
  final VoidCallback projectSyncStart;
  final VoidCallback todoSyncStart;

  _HomeContainer({
    @required this.projectSyncStart,
    @required this.todoSyncStart,
  });

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    if (settings.isInitialRoute || settings.name == "/") {
      return MaterialPageRoute(
        builder: (BuildContext context) => _HomePage(
              projectSyncStart: projectSyncStart,
              todoSyncStart: todoSyncStart,
            ),
      );
    } else if (settings.name == "/settings") {
      return MaterialPageRoute(builder: (context) => SettingsScreen());
    } else if (settings.name == "/settings/account") {
      return MaterialPageRoute(builder: (context) => ProfileScreen());
    } else {
      return MaterialPageRoute(
        builder: (BuildContext context) => Scaffold(
              body: Text("404"),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: mainNavigatorKey,
      theme: primaryTheme,
      onGenerateRoute: _onGenerateRoute,
      initialRoute: "/",
      // home: _HomePage(
      //   projectSyncStart: projectSyncStart,
      //   todoSyncStart: todoSyncStart,
      // ),
    );
  }
}

class _HomePage extends StatefulWidget {
  final VoidCallback projectSyncStart;
  final VoidCallback todoSyncStart;

  _HomePage({
    @required this.projectSyncStart,
    @required this.todoSyncStart,
  });

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  @override
  initState() {
    super.initState();
    widget.todoSyncStart();
    widget.projectSyncStart();
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    if (settings.isInitialRoute || settings.name == "/") {
      return MaterialPageRoute(
        builder: (BuildContext context) => InboxScreen(),
      );
    } else if (settings.name == "/all") {
      return MaterialPageRoute(
        builder: (BuildContext context) => AllTodosScreen(),
      );
    } else if (settings.name == "/today") {
      return MaterialPageRoute(
        builder: (BuildContext context) => TodayScreen(),
      );
    } else if (settings.name == "/7days") {
      return MaterialPageRoute(
        builder: (BuildContext context) => SevenDayScreen(),
      );
    } else if (settings.name == "/todos") {
      Map<String, dynamic> arguments = settings.arguments;
      final Project project = arguments['project'];
      return MaterialPageRoute(
        builder: (BuildContext context) => TodoList(
              filter: {'project': project.id},
              title: project.title,
            ),
      );
    }
    return MaterialPageRoute(
      builder: (BuildContext context) => Scaffold(
            body: Text("404"),
          ),
    );
  }

  Widget _buildHomeApp() {
    return AnimatedTheme(
      data: primaryTheme,
      isMaterialAppTheme: true,
      child: Navigator(
        initialRoute: '/',
        onGenerateRoute: _onGenerateRoute,
        key: navigatorKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    if (queryData.size.width >= 768) {
      return Material(
        child: Row(
          // direction: Axis.horizontal,
          children: <Widget>[
            Flexible(
              flex: 0,
              child: HomeAppDrawer(
                disablePop: true,
              ),
            ),
            Flexible(child: _buildHomeApp()),
          ],
        ),
      );
    }
    return Scaffold(
      key: homeScaffoldKey,
      primary: false,
      drawer: HomeAppDrawer(),
      body: _buildHomeApp(),
    );
  }
}

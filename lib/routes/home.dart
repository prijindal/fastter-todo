import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/homeappdrawer.dart';
import '../components/todolist.dart';

import '../fastter/fastter_action.dart';

import '../helpers/navigator.dart';
import '../helpers/theme.dart';

import '../models/project.model.dart';
import '../models/todo.model.dart';
import '../models/todocomment.model.dart';
import '../screens/profile.dart';
import '../screens/settings.dart';
import '../screens/todos.dart';
import '../store/state.dart';

class HomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _HomeContainer(
              projectSyncStart: () => store.dispatch(StartSync<Project>()),
              todoSyncStart: () => store.dispatch(StartSync<Todo>()),
              todoCommentsSyncStart: () =>
                  store.dispatch(StartSync<TodoComment>()),
            ),
      );
}

class _HomeContainer extends StatelessWidget {
  const _HomeContainer({
    @required this.projectSyncStart,
    @required this.todoSyncStart,
    @required this.todoCommentsSyncStart,
  });

  final VoidCallback projectSyncStart;
  final VoidCallback todoSyncStart;
  final VoidCallback todoCommentsSyncStart;

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    if (settings.isInitialRoute || settings.name == '/') {
      return MaterialPageRoute<void>(
        builder: (context) => _HomePage(
              projectSyncStart: projectSyncStart,
              todoSyncStart: todoSyncStart,
              todoCommentsSyncStart: todoCommentsSyncStart,
            ),
      );
    } else if (settings.name == '/settings') {
      return MaterialPageRoute<void>(builder: (context) => SettingsScreen());
    } else if (settings.name == '/settings/account') {
      return MaterialPageRoute<void>(builder: (context) => ProfileScreen());
    } else {
      return MaterialPageRoute<void>(
        builder: (context) => Scaffold(
              body: const Text('404'),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: mainNavigatorKey,
        theme: primaryTheme,
        onGenerateRoute: _onGenerateRoute,
        initialRoute: '/',
      );
}

class _HomePage extends StatefulWidget {
  const _HomePage({
    @required this.projectSyncStart,
    @required this.todoSyncStart,
    @required this.todoCommentsSyncStart,
  });

  final VoidCallback projectSyncStart;
  final VoidCallback todoSyncStart;
  final VoidCallback todoCommentsSyncStart;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  @override
  void initState() {
    super.initState();
    widget.todoSyncStart();
    widget.projectSyncStart();
    widget.todoCommentsSyncStart();
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    if (settings.isInitialRoute || settings.name == '/') {
      return MaterialPageRoute<void>(
        builder: (context) => InboxScreen(),
      );
    } else if (settings.name == '/all') {
      return MaterialPageRoute<void>(
        builder: (context) => AllTodosScreen(),
      );
    } else if (settings.name == '/today') {
      return MaterialPageRoute<void>(
        builder: (context) => TodayScreen(),
      );
    } else if (settings.name == '/7days') {
      return MaterialPageRoute<void>(
        builder: (context) => SevenDayScreen(),
      );
    } else if (settings.name == '/todos') {
      final Map<String, dynamic> arguments = settings.arguments;
      final Project project = arguments['project'];
      return MaterialPageRoute<void>(
        builder: (context) => TodoList(
              filter: <String, dynamic>{'project': project.id},
              title: project.title,
            ),
      );
    }
    return MaterialPageRoute<void>(
      builder: (context) => Scaffold(
            body: const Text('404'),
          ),
    );
  }

  Widget _buildHomeApp() => AnimatedTheme(
        data: primaryTheme,
        isMaterialAppTheme: true,
        child: Navigator(
          initialRoute: '/',
          onGenerateRoute: _onGenerateRoute,
          key: navigatorKey,
        ),
      );

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    if (queryData.orientation == Orientation.landscape) {
      return Material(
        child: Row(
          // direction: Axis.horizontal,
          children: <Widget>[
            const Flexible(
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
      drawer: const HomeAppDrawer(),
      body: _buildHomeApp(),
    );
  }
}

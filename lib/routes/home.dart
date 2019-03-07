import 'dart:math';
import 'package:flutter/material.dart';

import '../models/project.model.dart';
import '../components/todolist.dart';
import '../screens/todos.dart';
import '../components/homeappbar.dart';
import '../components/homeappdrawer.dart';
import '../helpers/navigator.dart';
import '../helpers/theme.dart';

class HomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: primaryTheme,
      home: _HomeContainer(),
    );
  }
}

class _HomeContainer extends StatelessWidget {
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
              showProject: false,
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
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: min(1200.0, queryData.size.width),
              maxHeight: min(800.0, queryData.size.height),
            ),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Flexible(
                  child: HomeAppDrawer(),
                ),
                Flexible(child: _buildHomeApp()),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: HomeAppBar(),
      drawer: HomeAppDrawer(),
      body: _buildHomeApp(),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/project.model.dart';
import '../components/todolist.dart';
import '../screens/todos.dart';
import '../helpers/theme.dart';

class HomeContainer extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: primaryTheme,
      home: InboxScreen(),
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

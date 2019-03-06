import 'package:flutter/material.dart';

import '../components/todolist.dart';
import '../screens/todos.dart';
import '../helpers/theme.dart';

class HomeContainer extends StatelessWidget {
  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    if (settings.isInitialRoute || settings.name == "/") {
      return MaterialPageRoute(
        builder: (BuildContext context) => AllTodosScreen(),
      );
    } else if (settings.name == "/inbox") {
      return MaterialPageRoute(
        builder: (BuildContext context) => InboxScreen(),
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
      var arguments = settings.arguments;
      return MaterialPageRoute(
        builder: (BuildContext context) => TodoList(
              filter: arguments,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: primaryTheme,
      home: AllTodosScreen(),
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

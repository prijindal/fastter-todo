import 'package:fastter_todo/screens/loading.dart';
import 'package:fastter_todo/screens/loginsplash.dart';
import 'package:flutter/material.dart';

import '../../models/project.model.dart';
import '../../models/label.model.dart';
import '../../models/todo.model.dart';

import '../../components/todolist.dart';
import '../../screens/about.dart';
import '../../screens/generalsettings.dart';
import '../../screens/privacypolicy.dart';
import '../../screens/profile.dart';
import '../../screens/settings.dart';
import '../../screens/todoedit.dart';
import '../../screens/todos.dart';

import 'pageroute.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final name = settings.name;
  print(name);
  if (name == '/') {
    return HomePageRoute<void>(
      builder: (context) => InboxScreen(),
    );
  } else if (name == '/all') {
    return HomePageRoute<void>(
      builder: (context) => AllTodosScreen(),
    );
  } else if (name == '/today') {
    return HomePageRoute<void>(
      builder: (context) => TodayScreen(),
    );
  } else if (name == '/7days') {
    return HomePageRoute<void>(
      builder: (context) => SevenDayScreen(),
    );
  } else if (name == '/todos') {
    final Map<String, dynamic> arguments =
        settings.arguments as Map<String, dynamic>;
    final filters = <String, dynamic>{};
    String title = "Todos";
    if (arguments.containsKey('label')) {
      final Label label = arguments['label'];
      filters['label'] = label.id;
      title = label.title;
    }
    if (arguments.containsKey('project')) {
      final Project project = arguments['project'];
      filters['project'] = project.id;
      title = project.title;
    }
    return HomePageRoute<void>(
      builder: (context) => TodoList(
        filter: filters,
        title: title,
      ),
    );
  } else if (name != null && name.startsWith('/todo/')) {
    final todoid = name.split('/todo/')[1];
    return HomePageRoute<void>(
      builder: (context) => TodoEditScreenFromId(
        todoid: todoid,
      ),
    );
  } else if (name == '/todo') {
    final Map<String, dynamic> arguments =
        settings.arguments as Map<String, dynamic>;
    final Todo todo = arguments['todo'];
    return HomePageRoute<void>(
      builder: (context) => TodoEditScreen(
        todo: todo,
      ),
    );
  } else if (name == '/settings') {
    return HomePageRoute<void>(builder: (context) => SettingsScreen());
  } else if (name == '/settings/account') {
    return HomePageRoute<void>(builder: (context) => ProfileScreen());
  } else if (name == '/settings/general') {
    return HomePageRoute<void>(builder: (context) => GeneralSettingsScreen());
  } else if (name == '/about') {
    return HomePageRoute<void>(builder: (context) => AboutScreen());
  } else if (name == '/privacypolicy') {
    return HomePageRoute<void>(builder: (context) => PrivacyPolicyScreen());
  }
  return HomePageRoute<void>(
    builder: (context) => Scaffold(
      body: const Text('404'),
    ),
  );
}

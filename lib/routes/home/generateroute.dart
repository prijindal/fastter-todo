import 'package:flutter/material.dart';

import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/todo.model.dart';

import '../../components/todolist.dart';
import '../../screens/generalsettings.dart';
import '../../screens/profile.dart';
import '../../screens/settings.dart';
import '../../screens/todoedit.dart';
import '../../screens/todos.dart';

import 'pageroute.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  if (settings.name == '/') {
    return HomePageRoute<void>(
      builder: (context) => InboxScreen(),
    );
  } else if (settings.name == '/all') {
    return HomePageRoute<void>(
      builder: (context) => AllTodosScreen(),
    );
  } else if (settings.name == '/today') {
    return HomePageRoute<void>(
      builder: (context) => TodayScreen(),
    );
  } else if (settings.name == '/7days') {
    return HomePageRoute<void>(
      builder: (context) => SevenDayScreen(),
    );
  } else if (settings.name == '/todos') {
    final Map<String, dynamic> arguments = settings.arguments;
    final filters = <String, dynamic>{};
    String title;
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
  } else if (settings.name.startsWith('/todo/')) {
    final todoid = settings.name.split('/todo/')[1];
    return HomePageRoute<void>(
      builder: (context) => TodoEditScreenFromId(
            todoid: todoid,
          ),
    );
  } else if (settings.name == '/todo') {
    final Map<String, dynamic> arguments = settings.arguments;
    final Todo todo = arguments['todo'];
    return HomePageRoute<void>(
      builder: (context) => TodoEditScreen(
            todo: todo,
          ),
    );
  } else if (settings.name == '/settings') {
    return HomePageRoute<void>(builder: (context) => SettingsScreen());
  } else if (settings.name == '/settings/account') {
    return HomePageRoute<void>(builder: (context) => ProfileScreen());
  } else if (settings.name == '/settings/general') {
    return HomePageRoute<void>(builder: (context) => GeneralSettingsScreen());
  }
  return HomePageRoute<void>(
    builder: (context) => Scaffold(
          body: const Text('404'),
        ),
  );
}

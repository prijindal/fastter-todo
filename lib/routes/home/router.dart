import 'dart:async';
import 'dart:io';
import 'package:fastter_todo/bloc.dart';
import 'package:fastter_todo/helpers/fastter_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../fastter/fastter.dart';
import '../../models/todo.model.dart';
import '../../models/settings.model.dart';
import '../../fastter/fastter_bloc.dart';
import '../../store/user.dart';
import '../../store/labels.dart';
import '../../store/notifications.dart';
import '../../store/projects.dart';
import '../../store/todocomments.dart';
import '../../store/todoreminders.dart';
import '../../store/todos.dart';

import '../../helpers/firebase.dart';
import '../../helpers/navigator.dart';
import '../../helpers/theme.dart';
import '../../screens/todoedit.dart';

import 'generateroute.dart' show onGenerateRoute;

class HomePage extends StatefulWidget {
  const HomePage({
    required this.frontPage,
  });

  final FrontPage frontPage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const MethodChannel platform =
      MethodChannel('app.channel.shared.data');

  @override
  void initState() {
    super.initState();
    _initRequests();
    _getSharedText();
  }

  Future<void> _getSharedText() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final sharedData = await platform.invokeMethod<String>('getSharedText');
      print(sharedData);
      if (sharedData != null && sharedData.isNotEmpty) {
        final event = AddEvent<Todo>(Todo(title: sharedData));
        fastterTodos.add(event);
        final todo = await event.completer.future;
        if (navigatorKey.currentState != null) {
          _openNewTodo(todo);
        } else {
          Timer(const Duration(milliseconds: 500), () => _openNewTodo(todo));
        }
      }
    }
  }

  void _openNewTodo(Todo todo) {
    navigatorKey.currentState?.push<void>(MaterialPageRoute<void>(
      builder: (context) => TodoEditScreen(
        todo: todo,
      ),
    ));
  }

  Future<void> _initRequests() async {
    startSyncAll();
    fastterLabels.queries.initSubscriptions(fastterLabels.add);
    fastterProjects.queries.initSubscriptions(fastterProjects.add);
    fastterTodos.queries.initSubscriptions(fastterTodos.add);
    fastterTodoComments.queries.initSubscriptions(fastterTodoComments.add);
    fastterTodoReminders.queries.initSubscriptions(fastterTodoReminders.add);
    fastterNotifications.queries.initSubscriptions(fastterNotifications.add);
    Fastter.instance.onConnect = () {
      fastterUser.add(ConfirmUserEvent(Fastter.instance.bearer));
    };
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey,
        theme: primaryTheme,
        onGenerateRoute: onGenerateRoute,
        initialRoute: widget.frontPage.route,
      );
}

import 'dart:async';
import 'dart:io';
import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/store/user.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import 'package:fastter_dart/models/todoreminder.model.dart';
import 'package:fastter_dart/models/notification.model.dart' as notification;
import 'package:fastter_dart/store/labels.dart';
import 'package:fastter_dart/store/notifications.dart';
import 'package:fastter_dart/store/projects.dart';
import 'package:fastter_dart/store/todocomments.dart';
import 'package:fastter_dart/store/todoreminders.dart';
import 'package:fastter_dart/store/todos.dart';
import 'package:fastter_todo/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fastter_dart/fastter/fastter.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/settings.model.dart';

import '../../helpers/firebase.dart';
import '../../helpers/navigator.dart';
import '../../helpers/theme.dart';
import '../../screens/todoedit.dart';

import 'generateroute.dart' show onGenerateRoute;

class HomePage extends StatefulWidget {
  const HomePage({
    @required this.frontPage,
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
        fastterTodos.dispatch(event);
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
    navigatorKey.currentState.push<void>(MaterialPageRoute<void>(
      builder: (context) => TodoEditScreen(
            todo: todo,
          ),
    ));
  }

  Future<void> _initRequests() async {
    fastterTodos.dispatch(SyncEvent<Todo>());
    fastterProjects.dispatch(SyncEvent<Project>());
    fastterLabels.dispatch(SyncEvent<Label>());
    fastterTodoComments.dispatch(SyncEvent<TodoComment>());
    fastterTodoReminders.dispatch(SyncEvent<TodoReminder>());
    fastterNotifications.dispatch(SyncEvent<notification.Notification>());
    fastterLabels.queries.initSubscriptions(fastterLabels.dispatch);
    fastterProjects.queries.initSubscriptions(fastterProjects.dispatch);
    fastterTodos.queries.initSubscriptions(fastterTodos.dispatch);
    fastterTodoComments.queries.initSubscriptions(fastterTodoComments.dispatch);
    fastterTodoReminders.queries
        .initSubscriptions(fastterTodoReminders.dispatch);
    fastterNotifications.queries
        .initSubscriptions(fastterNotifications.dispatch);
    Fastter.instance.onConnect = () {
      fastterUser.dispatch(ConfirmUserEvent(Fastter.instance.bearer));
    };
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey,
        theme: primaryTheme,
        onGenerateRoute: onGenerateRoute,
        initialRoute: "/about",
      );
}

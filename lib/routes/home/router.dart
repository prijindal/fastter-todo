import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/todo.model.dart';
import '../../models/settings.model.dart';
import '../../fastter/fastter_bloc.dart';
import '../../store/todos.dart';

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

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey,
        theme: primaryTheme,
        onGenerateRoute: onGenerateRoute,
        initialRoute: widget.frontPage.route,
      );
}

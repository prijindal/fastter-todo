import 'dart:async';

import '../fastter/fastter_bloc.dart';
import '../models/base.model.dart';
import '../models/project.model.dart';
import '../models/todo.model.dart';
import '../store/projects.dart';
import '../store/todos.dart';
import 'package:fastter_todo/bloc.dart';
import 'package:fastter_todo/routes/home.dart';
import 'package:fastter_todo/routes/home/generateroute.dart';
import 'package:fastter_todo/routes/home/pageroute.dart';
import 'package:fastter_todo/screens/loading.dart';
import 'package:fastter_todo/screens/loginsplash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user.model.dart';
import '../store/user.dart';

import '../helpers/flutter_persistor.dart';
import '../helpers/theme.dart';

class AppContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
        bloc: fastterUser,
        builder: (context, state) => const _AppContainer(),
      );
}

class _AppContainer extends StatefulWidget {
  const _AppContainer();

  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<_AppContainer> {
  final FlutterPersistor _flutterPersistor = FlutterPersistor();
  bool _isTodosLoading = true;
  bool _isProjectsLoading = true;
  bool _isWaiting = true;
  StreamSubscription<ListState<Todo>>? todosListener;
  StreamSubscription<ListState<Project>>? projectsListener;

  @override
  void initState() {
    super.initState();
    _init();
  }

  bool get _isLoading => _isTodosLoading || _isProjectsLoading;

  Future<void> _init() async {
    setState(() {
      _isTodosLoading = true;
      _isProjectsLoading = true;
    });
    await _flutterPersistor.load();
    _enableTryLoginTimer();
    todosListener = fastterTodos.stream.listen((event) {
      if (event is ListState<Todo>) {
        Timer.run(() {
          setState(() {
            _isTodosLoading = false;
          });
        });
      }
    });
    projectsListener = fastterProjects.stream.listen((event) {
      if (event is ListState<Project>) {
        Timer.run(() {
          setState(() {
            _isProjectsLoading = false;
          });
        });
      }
    });
    _flutterPersistor.initListeners();
  }

  void _enableTryLoginTimer() {
    setState(() {
      _isWaiting = true;
    });
    Timer? periodicTimer;
    periodicTimer = Timer.periodic(const Duration(milliseconds: 100), (_timer) {
      if (todosListener != null) {
        todosListener?.cancel();
      }
      if (projectsListener != null) {
        projectsListener?.cancel();
      }
      if (_isLoading) {
        return;
      }
      setState(() {
        _isWaiting = false;
      });
      periodicTimer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isWaiting) {
      return MaterialApp(
        theme: primaryTheme,
        home: LoadingScreen(),
      );
    }
    return HomeContainer();
  }
}

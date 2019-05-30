import 'dart:async';

import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/store/projects.dart';
import 'package:fastter_dart/store/todos.dart';
import 'package:fastter_todo/bloc.dart';
import 'package:fastter_todo/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fastter_dart/models/user.model.dart';
import 'package:fastter_dart/store/user.dart';

import '../helpers/flutter_persistor.dart';
import '../helpers/theme.dart';
import '../screens/loginsplash.dart';
import 'home.dart';

class AppContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<UserEvent, UserState>(
        bloc: fastterUser,
        builder: (context, state) => _AppContainer(
              user: state,
              confirmUser: (bearer) =>
                  fastterUser.dispatch(ConfirmUserEvent(bearer)),
              clearAuth: () => fastterUser.dispatch(LogoutUserEvent()),
            ),
      );
}

class _AppContainer extends StatefulWidget {
  const _AppContainer({
    @required this.user,
    @required this.confirmUser,
    @required this.clearAuth,
  });

  final UserState user;
  final void Function(String) confirmUser;
  final void Function() clearAuth;

  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<_AppContainer> {
  final FlutterPersistor _flutterPersistor = FlutterPersistor();
  bool _isUserLoading = true;
  bool _isTodosLoading = true;
  bool _isProjectsLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  bool get _isLoading =>
      _isUserLoading || _isTodosLoading || _isProjectsLoading;

  Future<void> _init() async {
    fastterUser.event.listen((event) {
      if (event is InitStateUserEvent) {
        Timer.run(() {
          setState(() {
            _isUserLoading = false;
          });
          _tryLogin();
        });
      }
    });
    fastterTodos.event.listen((event) {
      if (event is InitStateEvent<Todo>) {
        Timer.run(() {
          setState(() {
            _isTodosLoading = false;
          });
          _tryLogin();
        });
      }
    });
    fastterProjects.event.listen((event) {
      if (event is InitStateEvent<Project>) {
        Timer.run(() {
          setState(() {
            _isProjectsLoading = false;
          });
          _tryLogin();
        });
      }
    });
    await _flutterPersistor.load();
    _flutterPersistor.initListeners();
  }

  void _tryLogin() {
    if (_isLoading) {
      return;
    }
    if (widget.user == null || widget.user.bearer == null) {
      widget.clearAuth();
    } else {
      widget.confirmUser(widget.user.bearer);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        theme: primaryTheme,
        home: LoadingScreen(),
      );
    }
    if (widget.user == null ||
        widget.user.user == null ||
        widget.user.user.id == null) {
      return MaterialApp(
        theme: primaryTheme,
        home: LoginSplashScreen(),
      );
    }
    return HomeContainer();
  }
}

import 'dart:async';

import 'package:fastter_dart/fastter/fastter.dart';
import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/store/projects.dart';
import 'package:fastter_dart/store/todos.dart';
import 'package:fastter_todo/bloc.dart';
import 'package:fastter_todo/routes/home.dart';
import 'package:fastter_todo/routes/home/generateroute.dart';
import 'package:fastter_todo/routes/home/pageroute.dart';
import 'package:fastter_todo/screens/loading.dart';
import 'package:fastter_todo/screens/loginsplash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fastter_dart/models/user.model.dart';
import 'package:fastter_dart/store/user.dart';

import '../helpers/flutter_persistor.dart';
import '../helpers/theme.dart';

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
  bool _isWaiting = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  bool get _isLoading =>
      _isUserLoading || _isTodosLoading || _isProjectsLoading;

  Future<void> _init() async {
    setState(() {
      _isUserLoading = true;
      _isTodosLoading = true;
      _isProjectsLoading = true;
    });
    fastterUser.event.listen((event) {
      if (event is InitStateUserEvent) {
        Fastter.instance.bearer = event.initState.bearer;
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
    setState(() {
      _isWaiting = true;
    });
    if (_isLoading) {
      return;
    }
    Timer(Duration(milliseconds: 100), () {
      setState(() {
        _isWaiting = false;
      });
      if (widget.user == null || widget.user.bearer == null) {
        widget.clearAuth();
      } else {
        widget.confirmUser(widget.user.bearer);
      }
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
    if (widget.user == null || widget.user.bearer == null) {
      return MaterialApp(
        theme: primaryTheme,
        home: LoginSplashScreen(),
      );
    }
    return HomeContainer();
  }
}

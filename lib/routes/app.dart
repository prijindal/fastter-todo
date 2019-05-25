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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _flutterPersistor.load();
    _flutterPersistor.initListeners();
    await Future<void>.delayed(Duration(milliseconds: 100));
    setState(() {
      isLoading = false;
    });
    _tryLogin();
  }

  void _tryLogin() {
    if (widget.user == null || widget.user.bearer == null) {
      widget.clearAuth();
    } else {
      widget.confirmUser(widget.user.bearer);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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

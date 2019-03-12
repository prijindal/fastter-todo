import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../helpers/theme.dart';
import '../models/user.model.dart';
import '../screens/loading.dart';
import '../screens/login.dart';
import '../store/state.dart';
import '../store/user.dart';
import 'home.dart';

class AppContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _AppContainer(
              user: store.state.user,
              confirmUser: (bearer) =>
                  store.dispatch(ConfirmUserAction(bearer)),
              clearAuth: () => store.dispatch(LogoutUserAction()),
              rehydrated: store.state.rehydrated,
            ),
      );
}

class _AppContainer extends StatefulWidget {
  const _AppContainer({
    @required this.user,
    @required this.confirmUser,
    @required this.clearAuth,
    @required this.rehydrated,
  });

  final UserState user;
  final void Function(String) confirmUser;
  final void Function() clearAuth;
  final bool rehydrated;

  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<_AppContainer> {
  @override
  void initState() {
    super.initState();
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
    if (!widget.rehydrated || widget.user == null) {
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
        home: LoginScreen(),
      );
    }
    return HomeContainer();
  }
}

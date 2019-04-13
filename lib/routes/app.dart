import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/models/user.model.dart';
import 'package:fastter_dart/store/state.dart';
import 'package:fastter_dart/store/user.dart';

import '../helpers/theme.dart';
import '../helpers/firebase.dart';
import '../screens/loading.dart';
import '../screens/login.dart';
import 'home.dart';

class AppContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) =>
            store.state == null || store.state.rehydrated == false
                ? MaterialApp(
                    theme: primaryTheme,
                    home: LoadingScreen(),
                  )
                : _AppContainer(
                    user: store.state.user,
                    confirmUser: (bearer) =>
                        store.dispatch(ConfirmUserAction(bearer)),
                    clearAuth: () => store.dispatch(LogoutUserAction()),
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
    if (widget.user == null ||
        widget.user.user == null ||
        widget.user.user.id == null) {
      return MaterialApp(
        theme: primaryTheme,
        home: LoginScreen(),
        navigatorObservers: [
          analyticsObserver,
        ],
      );
    }
    return HomeContainer();
  }
}

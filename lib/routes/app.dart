import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../screens/loading.dart';
import '../models/user.model.dart';
import '../screens/login.dart';
import '../helpers/theme.dart';
import 'home.dart';
import '../store/state.dart';
import '../store/user.dart';

class AppContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _AppContainer(
          user: store.state.user,
          confirmUser: (String bearer) =>
              store.dispatch(ConfirmUserAction(bearer)),
          clearAuth: () => store.dispatch(LogoutUserAction()),
          rehydrated: store.state.rehydrated,
        );
      },
    );
  }
}

class _AppContainer extends StatefulWidget {
  _AppContainer({
    @required this.user,
    @required this.confirmUser,
    @required this.clearAuth,
    @required this.rehydrated,
  });

  final UserState user;
  final void Function(String) confirmUser;
  final void Function() clearAuth;
  final bool rehydrated;

  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<_AppContainer> {
  @override
  void initState() {
    super.initState();
    tryLogin();
  }

  void tryLogin() async {
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

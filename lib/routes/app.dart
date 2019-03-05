import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../screens/loading.dart';
import '../models/user.model.dart';
import '../screens/login.dart';
import '../helpers/theme.dart';
import 'home.dart';
import '../store/state.dart';
import '../store/bearer.dart';
import '../store/currentuser.dart';
import '../helpers/fastter.dart' show fastter, Request;

class AppContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _AppContainer(
          user: store.state.user,
          onLogin: (User user) => store.dispatch(LoginUserAction(user)),
          setBearer: (String bearer) => store.dispatch(InitAuthAction(bearer)),
          bearer: store.state.bearer,
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
    @required this.onLogin,
    @required this.setBearer,
    @required this.bearer,
    @required this.clearAuth,
    @required this.rehydrated,
  });

  final User user;
  final void Function(User) onLogin;
  final void Function(String) setBearer;
  final void Function() clearAuth;
  final String bearer;
  final bool rehydrated;

  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<_AppContainer> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tryLogin();
  }

  void tryLogin() {
    String bearer = widget.bearer;
    if (bearer != null) {
      fastter.bearer = bearer;
      setState(() {
        isLoading = true;
      });
      // Request
      fastter
          .request(new Request(
        query: '{current {_id, email}}',
      ))
          .then((resp) {
        CurrentData response = CurrentData.fromJson(resp);
        if (response != null && response.current != null) {
          widget.setBearer(bearer);
          widget.onLogin(response.current);
        } else {
          widget.clearAuth();
          fastter.bearer = null;
        }
        this.setState(() {
          isLoading = false;
        });
      });
    } else {
      widget.clearAuth();
      setState(() {
        isLoading = false;
      });
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
    if (widget.user == null || widget.user.id == null) {
      return MaterialApp(
        theme: primaryTheme,
        home: LoginScreen(),
      );
    }
    return HomeContainer();
  }
}

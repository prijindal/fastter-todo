import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../screens/loading.dart';
import '../models/user.model.dart';
import '../store/store.dart';
import '../store/currentuser.dart';
import '../helpers/fastter.dart' show fastter, Request;

class AppContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> state) {
        return _AppContainer(
          user: store.state.user,
          onLogin: (User user, bool isNew) =>
              store.dispatch(LoginUserAction(user)),
          bearer: state.state.bearer,
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
    @required this.bearer,
    @required this.clearAuth,
    @required this.rehydrated,
  });

  final User user;
  final void Function(User user, bool isNew) onLogin;
  final void Function() clearAuth;
  final String bearer;
  final bool rehydrated;

  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<_AppContainer> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fastter;
    tryLogin();
  }

  void tryLogin() {
    String bearer = widget.bearer;
    if (bearer != null) {
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
        this.setState(() {
          isLoading = false;
        });
        if (response != null &&
            response.current != null &&
            response.current.user != null) {
          widget.onLogin(response.current.user, false);
        } else {
          widget.clearAuth();
          fastter.bearer = null;
        }
      });
    }
  }

  login() {
    fastter.login('priyanshujindal1995@gmail.com', 'admin').then((response) {
      if (response != null && response.login != null) {
        widget.onLogin(response.login.user, true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    }
    if (widget.user == null || widget.user.id == null) {
      return FlatButton(
        child: Text("Login"),
        onPressed: login,
      );
    }
    return MaterialApp(
      title: 'Todo App',
      home: Text("Hello"),
    );
  }
}

import 'dart:math';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/user.model.dart';
import '../store/state.dart';
import '../store/user.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, void Function(String, String)>(
      converter: (Store<AppState> store) => (String email, String password) =>
          store.dispatch(LoginUserAction(email, password)),
      builder: (BuildContext context, fn) {
        return StoreConnector<AppState, UserState>(
            converter: (Store<AppState> store) => store.state.user,
            builder: (BuildContext context, userState) {
              return _LoginForm(
                login: (String email, String password) => fn(email, password),
                user: userState,
              );
            });
      },
    );
  }
}

class _LoginForm extends StatefulWidget {
  _LoginForm({
    @required this.login,
    @required this.user,
  });

  final UserState user;
  final void Function(String email, String password) login;

  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  TextEditingController emailController = new TextEditingController(text: "");
  TextEditingController passwordController =
      new TextEditingController(text: "");

  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();

  login() {
    widget.login(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: min(400.0, MediaQuery.of(context).size.width - 20.0),
        child: Form(
          autovalidate: true,
          child: Center(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: "Email",
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: "Password",
                  ),
                ),
                FlatButton(
                  child: Text("Login"),
                  onPressed: widget.user.isLoading ? null : login,
                ),
                Text(widget.user.errorMessage == null
                    ? ""
                    : widget.user.errorMessage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

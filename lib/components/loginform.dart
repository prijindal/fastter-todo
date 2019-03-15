import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/models/user.model.dart';
import 'package:fastter_dart/store/state.dart';
import 'package:fastter_dart/store/user.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, void Function(String, String)>(
        converter: (store) => (email, password) =>
            store.dispatch(LoginUserAction(email, password)),
        builder: (context, fn) => StoreConnector<AppState, UserState>(
              converter: (store) => store.state.user,
              builder: (context, userState) => _LoginForm(
                    login: (email, password) => fn(email, password),
                    user: userState,
                  ),
            ),
      );
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({
    @required this.login,
    @required this.user,
  });

  final UserState user;
  final void Function(String email, String password) login;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  void login() {
    widget.login(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          width: min(400, MediaQuery.of(context).size.width - 20.0),
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
                      icon: const Icon(Icons.email),
                      labelText: 'Email',
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                  ),
                  FlatButton(
                    child: const Text('Login'),
                    onPressed: widget.user.isLoading ? null : login,
                  ),
                  Text(widget.user.errorMessage == null
                      ? ''
                      : widget.user.errorMessage),
                ],
              ),
            ),
          ),
        ),
      );
}

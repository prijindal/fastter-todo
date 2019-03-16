import 'dart:math';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/models/user.model.dart';
import 'package:fastter_dart/store/state.dart';
import 'package:fastter_dart/store/user.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _SignupScreen(
              signup: (email, password) =>
                  store.dispatch(SignupUserAction(email, password)),
              user: store.state.user,
            ),
      );
}

class _SignupScreen extends StatefulWidget {
  const _SignupScreen({
    @required this.signup,
    @required this.user,
  });

  final UserState user;
  final void Function(String email, String password) signup;

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<_SignupScreen> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  void _signup() {
    widget.signup(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Signup'),
        ),
        body: Container(
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
                    RaisedButton(
                      child: const Text('Signup'),
                      onPressed: widget.user.isLoading ? null : _signup,
                    ),
                    Text(widget.user.errorMessage == null
                        ? ''
                        : widget.user.errorMessage),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

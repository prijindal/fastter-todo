import 'dart:math';
import 'package:fastter_todo/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fastter_dart/models/user.model.dart';
import 'package:fastter_dart/store/user.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<UserEvent, UserState>(
        bloc: fastterUser,
        builder: (context, userState) => _LoginForm(
              login: (email, password) =>
                  fastterUser.dispatch(LoginUserEvent(email, password)),
              user: userState,
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

  void _login() {
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
                  RaisedButton(
                    child: const Text('Login'),
                    onPressed: _login,
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

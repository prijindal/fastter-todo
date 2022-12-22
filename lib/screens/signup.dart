import 'dart:math';
import 'package:fastter_todo/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user.model.dart';
import '../store/user.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
        bloc: fastterUser,
        builder: (context, state) => _SignupScreen(
          signup: (email, password) =>
              fastterUser.add(SignupUserEvent(email, password)),
          user: state,
        ),
      );
}

class _SignupScreen extends StatefulWidget {
  const _SignupScreen({
    required this.signup,
    required this.user,
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    ElevatedButton(
                      child: const Text('Signup'),
                      onPressed: widget.user.isLoading ? null : _signup,
                    ),
                    Text(widget.user.errorMessage == null
                        ? ''
                        : widget.user.errorMessage!),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

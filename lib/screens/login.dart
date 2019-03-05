import 'dart:math';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/user.model.dart';
import '../store/store.dart';
import '../store/bearer.dart';
import '../store/currentuser.dart';
import '../helpers/fastter.dart' show fastter, Request;

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, void Function(User user)>(
      converter: (Store<AppState> store) =>
          (User user) => store.dispatch(LoginUserAction(user)),
      builder: (BuildContext context, fn) {
        return StoreConnector<AppState, void Function(String)>(
          converter: (Store<AppState> store) =>
              (String bearer) => store.dispatch(InitAuthAction(bearer)),
          builder: (BuildContext context, fnbearer) {
            return _LoginScreen(
              onLogin: (User user) => fn(user),
              setBearer: (String bearer) => fnbearer(bearer),
            );
          },
        );
      },
    );
  }
}

class _LoginScreen extends StatefulWidget {
  _LoginScreen({
    @required this.onLogin,
    @required this.setBearer,
  });

  final void Function(User user) onLogin;
  final void Function(String) setBearer;

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  bool isLoading = false;
  TextEditingController emailController =
      new TextEditingController(text: "priyanshujindal1995@gmail.com");
  TextEditingController passwordController =
      new TextEditingController(text: "admin");
  String errorMessage;

  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  login() {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });
    fastter
        .login(emailController.text, passwordController.text)
        .then((response) {
      if (response != null && response.login != null) {
        widget.setBearer(response.login.bearer);
        widget.onLogin(response.login.user);
        if (response.login.user == null) {
          setState(() {
            errorMessage = "Wrong username password";
          });
        }
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
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
                    onPressed: isLoading ? null : login,
                  ),
                  Text(errorMessage == null ? "" : errorMessage),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

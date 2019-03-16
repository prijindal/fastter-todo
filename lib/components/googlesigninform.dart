import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:fastter_dart/fastter/fastter.dart';
import 'package:fastter_dart/models/user.model.dart';
import 'package:fastter_dart/store/state.dart';
import 'package:fastter_dart/store/user.dart';

class GoogleSignInForm extends StatelessWidget {
  @protected
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, void Function(String)>(
        converter: (store) =>
            (idToken) => store.dispatch(GoogleLoginUserAction(idToken)),
        builder: (context, fn) => StoreConnector<AppState, UserState>(
              converter: (store) => store.state.user,
              builder: (context, userState) => _GoogleSignInForm(
                    loginWithGoogle: (idToken) => fn(idToken),
                    user: userState,
                  ),
            ),
      );
}

class _GoogleSignInForm extends StatelessWidget {
  const _GoogleSignInForm({
    @required this.loginWithGoogle,
    @required this.user,
  });

  final UserState user;
  final void Function(String) loginWithGoogle;

  void _startGoogleFlow(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      final _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
      _googleSignIn.signIn().then((account) {
        account.authentication.then((auth) {
          loginWithGoogle(auth.idToken);
        });
      });
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (context) => Scaffold(
                body: Center(
                  child: const CircularProgressIndicator(),
                ),
              ),
        ),
      );
    } else {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (context) => _GoogleSignInScreen(
                loginWithGoogle: loginWithGoogle,
                user: user,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        child: SignInButton(
          Buttons.Google,
          onPressed: () => _startGoogleFlow(context),
        ),
      );
}

class _GoogleSignInScreen extends StatefulWidget {
  const _GoogleSignInScreen({
    @required this.loginWithGoogle,
    @required this.user,
  });

  final UserState user;
  final void Function(String) loginWithGoogle;

  @override
  _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<_GoogleSignInScreen> {
  final _idTokenController = TextEditingController(text: '');
  final String urlString = '${Fastter.instance.url}/google/oauth2';

  @override
  void initState() {
    super.initState();
  }

  void _onLogin() {
    widget.loginWithGoogle(_idTokenController.text);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Sign in with google'),
        ),
        body: widget.user.isLoading
            ? Center(
                child: const CircularProgressIndicator(),
              )
            : Container(
                child: Column(
                  children: <Widget>[
                    const Text('Go to this url'),
                    Text(urlString),
                    const Text('And input the string below'),
                    TextField(
                      controller: _idTokenController,
                    ),
                    RaisedButton(
                      child: const Text('Login'),
                      onPressed: _onLogin,
                    )
                  ],
                ),
              ),
      );
}

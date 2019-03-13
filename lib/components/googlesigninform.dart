import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../fastter/fastter.dart';
import '../models/user.model.dart';
import '../store/state.dart';
import '../store/user.dart';

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

class _GoogleSignInForm extends StatefulWidget {
  const _GoogleSignInForm({
    @required this.loginWithGoogle,
    @required this.user,
  });

  final UserState user;
  final void Function(String) loginWithGoogle;

  @override
  _GoogleSignInFormState createState() => _GoogleSignInFormState();
}

class _GoogleSignInFormState extends State<_GoogleSignInForm> {
  void _startGoogleFlow() {
    if (Platform.isAndroid || Platform.isIOS) {
      final _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
      _googleSignIn.signIn().then((account) {
        account.authentication.then((auth) {
          widget.loginWithGoogle(auth.idToken);
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
                loginWithGoogle: widget.loginWithGoogle,
                user: widget.user,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        child: SignInButton(
          Buttons.Google,
          onPressed: _startGoogleFlow,
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
    launch(urlString);
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
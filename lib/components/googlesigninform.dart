import 'dart:io';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import '../fastter/fastter.dart';
import '../models/user.model.dart';
import '../store/state.dart';
import '../store/user.dart';

class GoogleSignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, void Function(String)>(
      converter: (Store<AppState> store) =>
          (String idToken) => store.dispatch(GoogleLoginUserAction(idToken)),
      builder: (BuildContext context, fn) {
        return StoreConnector<AppState, UserState>(
            converter: (Store<AppState> store) => store.state.user,
            builder: (BuildContext context, userState) {
              return _GoogleSignInForm(
                loginWithGoogle: (String idToken) => fn(idToken),
                user: userState,
              );
            });
      },
    );
  }
}

class _GoogleSignInForm extends StatefulWidget {
  _GoogleSignInForm({
    @required this.loginWithGoogle,
    @required this.user,
  });

  final UserState user;
  final void Function(String) loginWithGoogle;

  _GoogleSignInFormState createState() => _GoogleSignInFormState();
}

class _GoogleSignInFormState extends State<_GoogleSignInForm> {
  _startGoogleFlow() {
    if (Platform.isAndroid || Platform.isIOS) {
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
      _googleSignIn.signIn().then((account) {
        account.authentication.then((auth) {
          widget.loginWithGoogle(auth.idToken);
        });
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _GoogleSignInScreen(
                loginWithGoogle: widget.loginWithGoogle,
                user: widget.user,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Text("Google Sign In"),
        onPressed: _startGoogleFlow,
      ),
    );
  }
}

class _GoogleSignInScreen extends StatefulWidget {
  _GoogleSignInScreen({
    @required this.loginWithGoogle,
    @required this.user,
  });

  final UserState user;
  final void Function(String) loginWithGoogle;

  _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<_GoogleSignInScreen> {
  TextEditingController _idTokenController = TextEditingController(text: "");
  final String urlString = URL + "/google/oauth2";

  @override
  initState() {
    super.initState();
    launch(urlString);
  }

  _onLogin() {
    widget.loginWithGoogle(_idTokenController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in with google"),
      ),
      body: widget.user.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  Text("Go to this url"),
                  Text(urlString),
                  Text("And input the string below"),
                  TextField(
                    controller: _idTokenController,
                  ),
                  RaisedButton(
                    child: Text("Login"),
                    onPressed: _onLogin,
                  )
                ],
              ),
            ),
    );
  }
}

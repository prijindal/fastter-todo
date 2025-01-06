import 'package:auto_route/auto_route.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_login.dart';

// TODO: Replace this, this is only for firebase
@RoutePage()
class FirebaseProfileScreen extends StatelessWidget {
  const FirebaseProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ProfileScreen(
        providers: FirebaseLoginScreen.authProviders,
        actions: [
          SignedOutAction((context) {
            AutoRouter.of(context).pushNamed("/settings");
          }),
        ],
      ),
    );
  }
}

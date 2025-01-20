import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../firebase/firebase_init.dart';

@RoutePage()
class FirebaseLoginScreen extends StatelessWidget {
  const FirebaseLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Login with firebase"),
            ),
            body: SignInScreen(
              providers: authProviders,
            ),
          );
        }

        return const _LoginChecker();
      },
    );
  }
}

class _LoginChecker extends StatefulWidget {
  const _LoginChecker();

  @override
  State<_LoginChecker> createState() => __LoginCheckerState();
}

class __LoginCheckerState extends State<_LoginChecker> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 100),
      _checkCurrentUser,
    );
  }

  void _checkCurrentUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      AutoRouter.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }
}

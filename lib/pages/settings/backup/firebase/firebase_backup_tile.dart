import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../firebase/firebase_init.dart' show User, FirebaseAuth;

class FirebaseBackupTile extends StatefulWidget {
  const FirebaseBackupTile({super.key});

  @override
  State<FirebaseBackupTile> createState() => _FirebaseBackupTileState();
}

class _FirebaseBackupTileState extends State<FirebaseBackupTile> {
  StreamSubscription<User?>? _subscription;
  User? user;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    _subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        this.user = user;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Image.asset(
                  'assets/icon/firebase.png',
                  width: 48,
                ),
                title: Text(user!.displayName ?? user!.email ?? user!.uid),
                subtitle: Text(user!.email ?? user!.uid),
                onTap: () async {
                  await AutoRouter.of(context).pushNamed(
                    "/firebase/backup",
                  );
                },
              ),
            ],
          )
        : ListTile(
            leading: Image.asset(
              'assets/icon/firebase.png',
              width: 48,
            ),
            title: const Text(
              "Login with firebase",
            ),
            onTap: () async {
              await AutoRouter.of(context).pushNamed("/firebase/login");
            },
          );
  }
}

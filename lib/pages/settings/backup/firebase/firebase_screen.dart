import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_sync.dart';

@RoutePage()
class FirebaseBackupScreen extends StatefulWidget {
  const FirebaseBackupScreen({super.key});

  @override
  State<FirebaseBackupScreen> createState() => _FirebaseBackupScreenState();
}

class _FirebaseBackupScreenState extends State<FirebaseBackupScreen> {
  @override
  void initState() {
    Provider.of<FirebaseSync>(context, listen: false).checkSignIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseSync = Provider.of<FirebaseSync>(context);
    final user = firebaseSync.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings -> Backup -> Firebase"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading:
                user?.photoURL != null ? Image.network(user!.photoURL!) : null,
            title: Text(user?.displayName ??
                user?.email ??
                user?.uid ??
                "Not signed in"),
            subtitle: Text(user?.email ?? user?.uid ?? "Not found"),
            onTap: () async {
              await AutoRouter.of(context).pushNamed(
                "/firebase/profile",
              );
            },
          ),
          ListTile(
            title: Text(firebaseSync.syncStatus.title),
            subtitle: firebaseSync.metadata == null
                ? null
                : Text(firebaseSync.metadata!.toString()),
          ),
          ListTile(
            title: const Text("Upload"),
            onTap: () => firebaseSync.upload(context),
          ),
          ListTile(
            title: const Text("Download"),
            onTap: () => firebaseSync.download(context),
          ),
          ListTile(
            title: const Text("Sync"),
            onTap: () => firebaseSync.sync(ScaffoldMessenger.of(context)),
          ),
          ListTile(
            title: const Text("Logout"),
            onTap: () async {
              await firebaseSync.signOut();
            },
          )
        ],
      ),
    );
  }
}

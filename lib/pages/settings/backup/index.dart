import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../../helpers/fileio.dart';
import '../../../helpers/logger.dart';
import '../components/backup_encryption_tile.dart';
import 'firebase/firebase_backup_tile.dart';

bool isFirebaseInitialized() {
  try {
    return Firebase.apps.isNotEmpty;
  } catch (e, stack) {
    AppLogger.instance.e(
      "Firebase.apps error",
      error: e,
      stackTrace: stack,
    );
    return false;
  }
}

@RoutePage()
class BackupSettingsScreen extends StatelessWidget {
  const BackupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings -> Backup"),
      ),
      body: ListView(children: [
        const ListTile(
          title: Text("Local Backup"),
          dense: true,
        ),
        ListTile(
          title: const Text("Download as JSON"),
          onTap: () => downloadContent(context),
        ),
        ListTile(
          title: const Text("Upload from file"),
          onTap: () => uploadContent(context),
        ),
        const CloudBackupTile(),
      ]),
    );
  }
}

class CloudBackupTile extends StatelessWidget {
  const CloudBackupTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: Text("Cloud Backup"),
          dense: true,
        ),
        if (isFirebaseInitialized()) const FirebaseBackupTile(),
        const BackupEncryptionTile(),
      ],
    );
  }
}

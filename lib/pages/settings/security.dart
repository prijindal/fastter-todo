import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import 'components/backup_encryption_tile.dart';

@RoutePage()
class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings -> Security"),
      ),
      body: ListView(children: [
        const ListTile(
          title: Text("Backup Encryption"),
          dense: true,
        ),
        const BackupEncryptionTile(),
      ]),
    );
  }
}

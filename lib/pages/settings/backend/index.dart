import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:restart_app/restart_app.dart';

import '../../../db/db_crud_operations.dart';
import '../../../models/local_db_state.dart';

@RoutePage()
class BackendSettingsScreen extends StatelessWidget {
  const BackendSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings -> Backend"),
      ),
      body: ListView(children: [
        ListTile(
          title: Text("Reset Database"),
          onTap: () async {
            try {
              await GetIt.I<DbCrudOperations>().resetDatabase();
              // ignore: use_build_context_synchronously
              await GetIt.I<LocalDbState>().clear();
              await Restart.restartApp(
                notificationTitle: 'Restarting App',
                notificationBody: 'Please tap here to open the app again.',
              );
            } catch (e) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Error: $e"),
              ));
            }
          },
        ),
      ]),
    );
  }
}

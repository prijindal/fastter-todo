import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:watch_it/watch_it.dart';

import '../../../db/backend_sync_configuration.dart';
import '../../../db/db_crud_operations.dart';
import '../../../helpers/logger.dart';
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
        const ListTile(
          title: Text("Database Backend"),
          dense: true,
        ),
        const BackendImplementationTile(),
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

class BackendImplementationTile extends WatchingWidget {
  const BackendImplementationTile({super.key});

  Future<BackendSyncConfiguration?> _showRemoteSettingsDialog(
      BuildContext context) async {
    final urlController = TextEditingController();
    final jwtTokenController = TextEditingController();
    final remoteDbSettings = await showDialog<BackendSyncConfiguration?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input connection information'),
        content: AutofillGroup(
          child: Column(
            children: [
              TextField(
                controller: urlController,
                autofillHints: [AutofillHints.url],
                decoration: InputDecoration(hintText: "Enter your url here"),
              ),
              TextField(
                controller: jwtTokenController,
                autofillHints: [AutofillHints.password],
                decoration: InputDecoration(hintText: "Enter your token here"),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop<BackendSyncConfiguration?>(null);
            },
          ),
          TextButton(
            child: const Text('Submit'),
            onPressed: () {
              Navigator.of(context).pop<BackendSyncConfiguration>(
                BackendSyncConfiguration(
                  url: urlController.text,
                  jwtToken: jwtTokenController.text,
                ),
              );
              // Handle the submit action
            },
          ),
        ],
      ),
    );
    return remoteDbSettings;
  }

  Future<void> onChange(BuildContext context, bool? newValue) async {
    if (newValue == true) {
      final settings = await _showRemoteSettingsDialog(context);
      if (settings == null) {
        return;
      } else {
        await GetIt.I<BackendSyncConfigurationService>().setRemote(settings);
      }
    } else {
      await GetIt.I<BackendSyncConfigurationService>().clearRemote();
    }
    await Restart.restartApp(
      notificationTitle: 'Restarting App',
      notificationBody: 'Please tap here to open the app again.',
    );
  }

  Widget _buildTitle(BuildContext context) {
    final backendSyncConfiguration = watchPropertyValue(
        (BackendSyncConfigurationService s) => s.backendSyncConfiguration);
    return CheckboxListTile(
      value: backendSyncConfiguration != null,
      title: Text("Backend Sync"),
      onChanged: (newValue) async {
        try {
          await onChange(context, newValue);
        } catch (e) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error: $e"),
          ));
          AppLogger.instance.e(e.toString(), error: e);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text("Select backend implementation"),
      title: _buildTitle(context),
    );
  }
}

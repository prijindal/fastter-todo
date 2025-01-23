import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import '../../../models/db_manager.dart';
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
              await Provider.of<DbManager>(context, listen: false)
                  .resetDatabase();
              await Provider.of<LocalDbState>(context, listen: false).clear();
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

class BackendImplementationTile extends StatelessWidget {
  const BackendImplementationTile({super.key});

  Future<RemoteDbSettings?> _showRemoteSettingsDialog(
      BuildContext context) async {
    final urlController = TextEditingController();
    final jwtTokenController = TextEditingController();
    final remoteDbSettings = await showDialog<RemoteDbSettings?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Input connection information'),
        content: Column(
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(hintText: "Enter your url here"),
            ),
            TextField(
              controller: jwtTokenController,
              decoration: InputDecoration(hintText: "Enter your token here"),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop<RemoteDbSettings?>(null);
            },
          ),
          TextButton(
            child: const Text('Submit'),
            onPressed: () {
              Navigator.of(context).pop<RemoteDbSettings>(
                RemoteDbSettings(
                  url: urlController.text,
                  token: jwtTokenController.text.isEmpty
                      ? null
                      : jwtTokenController.text,
                  implementationType: RemoteDbImplementationType.hrana,
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

  Widget _buildTitle(BuildContext context) {
    final dbSelector = Provider.of<DbManager>(context, listen: false);
    final dbType = dbSelector.dbType;
    return DropdownButton<DbSelectorType>(
      value: dbType,
      items: DbSelectorType.values
          .map(
            (e) => DropdownMenuItem<DbSelectorType>(
              value: e,
              child: Text(e.name),
            ),
          )
          .toList(),
      onChanged: (newValue) async {
        if (newValue == DbSelectorType.remote) {
          final settings = await _showRemoteSettingsDialog(context);
          if (settings == null) {
            return;
          } else {
            await dbSelector.setRemote(settings);
          }
        } else {
          await dbSelector.setLocal();
        }
        await dbSelector.initDb();
        await Restart.restartApp(
          notificationTitle: 'Restarting App',
          notificationBody: 'Please tap here to open the app again.',
        );
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

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../components/adaptive_scaffold.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(children: [
        ListTile(
          leading: const Icon(Icons.style),
          title: const Text("Styling"),
          onTap: () => AutoRouter.of(context).pushPath("/settings/styling"),
        ),
        ListTile(
          leading: const Icon(Icons.code),
          title: const Text("Backend"),
          onTap: () => AutoRouter.of(context).pushPath("/settings/backend"),
        ),
        ListTile(
          leading: const Icon(Icons.backup),
          title: const Text("Backup"),
          onTap: () => AutoRouter.of(context).pushPath("/settings/backup"),
        ),
        ListTile(
          leading: const Icon(Icons.security_update),
          title: const Text("Permissions"),
          onTap: () => AutoRouter.of(context).pushPath("/settings/permissions"),
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text("Scheduled notifications"),
          onTap: () =>
              AutoRouter.of(context).pushPath("/settings/notifications"),
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text("Help"),
          onTap: () => AutoRouter.of(context).pushPath("/settings/help"),
        ),
        // TODO: Add settings for group by
        // TODO: Add settings for date format
        // TODO: Add settings for sync on or off, add ability to sync every x days
        // TODO: Add settings for default view
        // TODO: Add settings for save on back button
      ]),
    );
  }
}

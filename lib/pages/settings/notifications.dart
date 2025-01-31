import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

import '../../components/adaptive_scaffold.dart';
import '../../models/local_db_state.dart';

@RoutePage()
class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        title: const Text("Settings -> Notifications"),
      ),
      body: FutureBuilder<List<PendingNotificationRequest>>(
        future: () async {
          await GetIt.I<LocalDbState>().localNotificationsManager.init();
          // ignore: use_build_context_synchronously
          return GetIt.I<LocalDbState>()
              .localNotificationsManager
              .pendingNotificationRequests();
        }(),
        builder: (_, notifications) => ListView.builder(
          itemCount: notifications.data?.length ?? 0,
          itemBuilder: (context, index) {
            final notification = notifications.data![index];
            return ListTile(
              title: Text(notification.title ?? "Unknow"),
              subtitle: Text(notification.body ?? "Unknow"),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  GetIt.I<LocalDbState>()
                      .localNotificationsManager
                      .cancelNotification(notification.id);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

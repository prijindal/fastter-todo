import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

import '../../components/adaptive_scaffold.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';

class PendingNotificationPayload {
  final ReminderData reminder;
  final PendingNotificationRequest pendingNotificationRequest;

  PendingNotificationPayload(
      {required this.reminder, required this.pendingNotificationRequest});
}

@RoutePage()
class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  Future<List<PendingNotificationPayload>> _getPendingNotifications() async {
    await GetIt.I<LocalDbState>().localNotificationsManager.init();
    // ignore: use_build_context_synchronously
    final pendingNotificationRequests = await GetIt.I<LocalDbState>()
        .localNotificationsManager
        .pendingNotificationRequests();
    final reminders = GetIt.I<LocalDbState>().reminders;
    return pendingNotificationRequests
        .map((pendingNotificationRequest) => PendingNotificationPayload(
            reminder: reminders
                .singleWhere((a) => a.id == pendingNotificationRequest.payload),
            pendingNotificationRequest: pendingNotificationRequest))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        title: const Text("Settings -> Notifications"),
      ),
      body: FutureBuilder<List<PendingNotificationPayload>>(
        future: _getPendingNotifications(),
        builder: (_, notifications) => ListView.builder(
          itemCount: notifications.data?.length ?? 0,
          itemBuilder: (context, index) {
            final notification = notifications.data![index];
            return ListTile(
              title: Text(
                  notification.pendingNotificationRequest.title ?? "Unknown"),
              subtitle: Column(
                children: [
                  Text(notification.pendingNotificationRequest.body ??
                      "Unknown"),
                  Text(notification.reminder.time.toIso8601String())
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  GetIt.I<LocalDbState>()
                      .localNotificationsManager
                      .cancelNotification(
                          notification.pendingNotificationRequest.id);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

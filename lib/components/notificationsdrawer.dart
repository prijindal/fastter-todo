import '../fastter/fastter_bloc.dart';
import '../store/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/base.model.dart';
import '../models/notification.model.dart' as notification;

import 'notificationitem.dart';

class NotificationsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<
          FastterBloc<notification.Notification>,
          ListState<notification.Notification>>(
        bloc: fastterNotifications,
        builder: (context, state) => _NotificationsDrawer(
          notifications: state,
        ),
      );
}

class _NotificationsDrawer extends StatelessWidget {
  const _NotificationsDrawer({
    required this.notifications,
  });

  final ListState<notification.Notification> notifications;

  @override
  Widget build(BuildContext context) => Drawer(
        child: notifications.items.isEmpty
            ? const Center(
                child: Text('No Notifications Found'),
              )
            : ListView.builder(
                itemCount: notifications.items.length,
                itemBuilder: (context, index) => NotificationItem(
                  key: Key(notifications.items[index].id),
                  notification: notifications.items[index],
                ),
              ),
      );
}

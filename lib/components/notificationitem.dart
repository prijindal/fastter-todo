import 'package:fastter_dart/store/notifications.dart';
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        required,
        Widget,
        BuildContext,
        ListTile,
        Text,
        Navigator;
import 'package:redux/redux.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/models/notification.model.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({@required this.notification});

  final Notification notification;

  @override
  Widget build(BuildContext context) => _NotificationItem(
        markRead: () {
          notification.read = true;
          fastterNotifications.dispatch(
              UpdateEvent<Notification>(notification.id, notification));
        },
        notification: notification,
      );
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    @required this.notification,
    @required this.markRead,
  });

  final Notification notification;
  final void Function() markRead;

  void _onTap(BuildContext context) {
    markRead();
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(notification.route);
  }

  @override
  Widget build(BuildContext context) => ListTile(
        enabled: notification.read == false,
        title: Text(notification.title),
        subtitle: Text(notification.body),
        onTap: () => _onTap(context),
      );
}

import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/notification.model.dart' as notification;
import 'package:fastter_dart/store/state.dart';

import 'notificationitem.dart';

class NotificationsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _NotificationsDrawer(
              notifications: store.state.notifications,
            ),
      );
}

class _NotificationsDrawer extends StatelessWidget {
  const _NotificationsDrawer({
    @required this.notifications,
    Key key,
  }) : super(key: key);

  final ListState<notification.Notification> notifications;

  @override
  Widget build(BuildContext context) => Drawer(
        child: notifications.items.isEmpty
            ? const Center(
                child: Text('No Notifications Found'),
              )
            : ListView(
                children: [
                  const ListTile(
                    title: Text('Notifications'),
                  ),
                  ...notifications.items
                      .map(
                        (notification) => NotificationItem(
                              notification: notification,
                            ),
                      )
                      .toList(),
                ],
              ),
      );
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'navigator.dart';

import 'navigator.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<String> initMessaging() async {
  if (Platform.isAndroid || Platform.isIOS) {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onResume: (message) {
        if (message.containsKey('data') &&
            (message['data'] as Map<String, dynamic>).containsKey('route')) {
          navigatorKey.currentState.pushNamed(message['data']['route']);
        }
      },
      onMessage: (message) {
        Scaffold.of(navigatorKey.currentContext).showSnackBar(
          SnackBar(
            content: Text(message['notification']['title']),
            action: message.containsKey('data') &&
                    (message['data'] as Map<String, dynamic>)
                        .containsKey('route')
                ? SnackBarAction(
                    label: 'Open',
                    onPressed: () {
                      navigatorKey.currentState
                          .pushNamed(message['data']['route']);
                    },
                  )
                : null,
          ),
        );
      },
    );
    return _firebaseMessaging.getToken();
  }
  return null;
}

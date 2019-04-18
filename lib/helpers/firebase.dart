import 'dart:io';
import 'package:fastter_dart/models/user.model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'navigator.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
FirebaseAnalytics _analytics = FirebaseAnalytics();
FirebaseAnalyticsObserver analyticsObserver = FirebaseAnalyticsObserver(
  analytics: _analytics,
);

void initUserAnalytics(User user) {
  if (Platform.isAndroid || Platform.isIOS) {
    _analytics.setUserId(user.id);
    _analytics.setUserProperty(name: 'name', value: user.name);
    _analytics.setUserProperty(name: 'email', value: user.email);
  }
}

Future<String> initMessaging() async {
  if (Platform.isAndroid || Platform.isIOS) {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onLaunch: (message) {
        if (message.containsKey('data') &&
            (message['data']).containsKey('route')) {
          navigatorKey.currentState.pushNamed(message['data']['route']);
        }
      },
      onResume: (message) {
        if (message.containsKey('data') &&
            (message['data']).containsKey('route')) {
          navigatorKey.currentState.pushNamed(message['data']['route']);
        }
      },
      onMessage: (message) {
        // TODO(prijindal): Do this with subscriptions and state
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(message['notification']['title']),
        //     action: message.containsKey('data') &&
        //             (message['data'] as Map<String, dynamic>)
        //                 .containsKey('route')
        //         ? SnackBarAction(
        //             label: 'Open',
        //             onPressed: () {
        //               Navigator.of(context)
        //                   .pushNamed(message['data']['route']);
        //             },
        //           )
        //         : null,
        //   ),
        // );
      },
    );
    return _firebaseMessaging.getToken();
  }
  return null;
}

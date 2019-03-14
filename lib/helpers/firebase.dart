import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'navigator.dart';

import '../fastter/fastter.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

void initMessaging() async {
  if (Platform.isAndroid || Platform.isIOS) {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(onMessage: (message) {
      Scaffold.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text(message['notification']['title']),
        ),
      );
    });
    String fcmToken = await _firebaseMessaging.getToken();
    await Fastter.instance.request(
      Request(
        query: '''
                mutation(\$fcmToken: String!, \$platform:String!) {
                  registerFcmCurrentUser(fcmToken: \$fcmToken, platform:\$platform) {
                    registered
                  }
                }
              ''',
        variables: {
          'fcmToken': fcmToken,
          'platform': Platform.isAndroid ? "android" : "ios",
        },
      ),
    );
  }
}

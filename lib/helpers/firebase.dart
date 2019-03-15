import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'navigator.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<String> initMessaging() async {
  if (Platform.isAndroid || Platform.isIOS) {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(onMessage: (message) {
      Scaffold.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text(message['notification']['title']),
        ),
      );
    });
    return await _firebaseMessaging.getToken();
  }
  return null;
}

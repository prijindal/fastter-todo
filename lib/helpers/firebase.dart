import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'navigator.dart';

// FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<String> initMessaging() async {
  // _firebaseMessaging.requestPermission(alert: true);
  // _firebaseMessaging.configure(
  //   onLaunch: (message) {
  //     if (message.containsKey('data') &&
  //         (message['data']).containsKey('route')) {
  //       navigatorKey.currentState.pushNamed(message['data']['route']);
  //     }
  //   },
  //   onResume: (message) {
  //     if (message.containsKey('data') &&
  //         (message['data']).containsKey('route')) {
  //       navigatorKey.currentState.pushNamed(message['data']['route']);
  //     }
  //   },
  //   onMessage: (message) {
  //     // TODO(prijindal): Do this with subscriptions and state
  //     // Scaffold.of(context).showSnackBar(
  //     //   SnackBar(
  //     //     content: Text(message['notification']['title']),
  //     //     action: message.containsKey('data') &&
  //     //             (message['data'] as Map<String, dynamic>)
  //     //                 .containsKey('route')
  //     //         ? SnackBarAction(
  //     //             label: 'Open',
  //     //             onPressed: () {
  //     //               Navigator.of(context)
  //     //                   .pushNamed(message['data']['route']);
  //     //             },
  //     //           )
  //     //         : null,
  //     //   ),
  //     // );
  //   },
  // );
  // return _firebaseMessaging.getToken();
  return "";
}

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'routes/app.dart';

Future<void> main() async {
  // var isInDebugMode = false;
  // if (!kReleaseMode) {
  //   isInDebugMode = true;
  // }

  // FlutterError.onError = (details) {
  //   if (isInDebugMode) {
  //     FlutterError.dumpErrorToConsole(details);
  //   } else {
  //     Zone.current.handleUncaughtError(details.exception, details.stack);
  //   }
  // };

  await runZonedGuarded<Future<void>>(() async {
    runApp(AppContainer());
  }, (error, stackTrace) async {
    debugPrint(error.toString());
  });
}

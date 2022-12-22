import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'routes/app.dart';

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  if (Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  }
}

Future<void> main() async {
  _setTargetPlatformForDesktop();
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

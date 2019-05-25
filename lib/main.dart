import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'routes/app.dart';

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

Future<void> main() async {
  _setTargetPlatformForDesktop();
  var isInDebugMode = false;
  if (!kReleaseMode) {
    isInDebugMode = true;
  }

  FlutterError.onError = (details) {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await runZoned<Future<void>>(() async {
    runApp(AppContainer());
  }, onError: (dynamic error, dynamic stackTrace) async {
    debugPrint(error.toString());
  });
}

import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './app/app.dart';
import './firebase_options.dart';
import './helpers/logger.dart';

void main() async {
  runApp(
    const MyApp(),
  );
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      // Firebase app check is only supported on these platforms
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
      );
    }
  } catch (e, stack) {
    AppLogger.instance.e(
      "Firebase cannot be initialized",
      error: e,
      stackTrace: stack,
    );
  }
}

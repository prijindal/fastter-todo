import 'package:flutter/material.dart';

import './app/app.dart';
import './helpers/logger.dart';
import 'firebase/firebase_init.dart';

void main() async {
  runApp(
    const MyApp(),
  );
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await firebaseInit();
  } catch (e, stack) {
    AppLogger.instance.e(
      "Firebase cannot be initialized",
      error: e,
      stackTrace: stack,
    );
  }
}

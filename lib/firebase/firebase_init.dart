import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart' show AuthCredential;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'
    show AuthProvider, AuthListener, EmailAuthProvider;
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../firebase_options.dart';
import '../helpers/logger.dart';

export 'package:firebase_auth/firebase_auth.dart'
    show User, FirebaseAuth, AuthCredential, FirebaseException;
export 'package:firebase_core/firebase_core.dart'
    show Firebase, FirebaseOptions;
export 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
export 'package:firebase_ui_auth/firebase_ui_auth.dart'
    show SignInScreen, ProfileScreen, SignedOutAction;

final List<AuthProvider<AuthListener, AuthCredential>> authProviders = [
  EmailAuthProvider(),
];

Future<void> firebaseInit() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
    // Firebase app check is only supported on these platforms
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
    );
  }
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

bool isFirebaseInitialized() {
  try {
    return Firebase.apps.isNotEmpty;
  } catch (e, stack) {
    AppLogger.instance.e(
      "Firebase.apps error",
      error: e,
      stackTrace: stack,
    );
    return false;
  }
}

class CrashlyticsLogPrinter extends PrettyPrinter {
  CrashlyticsLogPrinter() : super();

  @override
  List<String> log(LogEvent event) {
    /// This sends logs of warning level and above to Crashlytics
    if (isFirebaseInitialized()) {
      if (event.level.index >= Level.warning.index) {
        FirebaseCrashlytics.instance.recordError(
          event.message,
          event.stackTrace,
          fatal: true,
          information: [event.level],
          printDetails: false,
        );
      } else {
        FirebaseCrashlytics.instance.log(event.message.toString());
      }
    }
    return super.log(event);
  }
}

String parseErrorToString(
  Object e,
  StackTrace stack, [
  String defaultMessage = "Error While syncing",
]) {
  AppLogger.instance.e(
    defaultMessage,
    error: e,
    stackTrace: stack,
  );
  var error = defaultMessage;
  if (e is FirebaseException && e.message != null) {
    error = e.message!;
  }
  return error;
}

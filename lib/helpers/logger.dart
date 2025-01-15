import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

import '../pages/settings/backup/index.dart';

class CrashlyticsLogPrinter extends PrettyPrinter {
  CrashlyticsLogPrinter() : super();

  @override
  List<String> log(LogEvent event) {
    /// This sends logs of warning level and above to Crashlytics
    if (event.level.index >= Level.warning.index) {
      if (isFirebaseInitialized()) {
        FirebaseCrashlytics.instance.recordError(
          event.message,
          event.stackTrace,
          fatal: true,
          information: [event.level],
          printDetails: false,
        );
      }
    }
    return super.log(event);
  }
}

class AppLogger extends Logger {
  static AppLogger? _logger;

  AppLogger() : super(printer: CrashlyticsLogPrinter());

  static AppLogger get instance {
    _logger ??= AppLogger();
    return _logger as AppLogger;
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

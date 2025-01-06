import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AppLogger extends Logger {
  static AppLogger? _logger;

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

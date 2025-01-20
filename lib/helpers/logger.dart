import 'package:logger/logger.dart';

import '../firebase_init.dart';

class AppLogger extends Logger {
  static AppLogger? _logger;

  AppLogger() : super(printer: CrashlyticsLogPrinter());

  static AppLogger get instance {
    _logger ??= AppLogger();
    return _logger as AppLogger;
  }
}

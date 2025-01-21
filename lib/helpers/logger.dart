import 'package:logger/logger.dart';

class AppLogger extends Logger {
  static AppLogger? _logger;

  static AppLogger get instance {
    _logger ??= AppLogger();
    return _logger as AppLogger;
  }
}

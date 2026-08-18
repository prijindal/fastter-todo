import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class LocalSettings {
  final SharedPreferencesAsync sharedPreferences;
  static String appSettingsFileName =
      Platform.environment['APP_SETTINGS_FILE_NAME'] ??
          String.fromEnvironment('APP_SETTINGS_FILE_NAME',
              defaultValue: "shared_preferences");

  LocalSettings(this.sharedPreferences);

  static Future<LocalSettings> init() async {
    final prefs = SharedPreferencesAsync(
        // options: SharedPreferencesLinuxOptions(fileName: appSettingsFileName),
        );
    return LocalSettings(prefs);
  }
}

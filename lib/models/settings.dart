import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;

import '../helpers/constants.dart';
import '../helpers/logger.dart';

enum ColorSeed {
  baseColor('Default', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

class SettingsStorageNotifier with ChangeNotifier {
  ColorSeed _baseColor;
  ThemeMode _themeMode;
  String _defaultRoute;

  SettingsStorageNotifier({
    ThemeMode themeMode = ThemeMode.system,
    ColorSeed baseColor = ColorSeed.baseColor,
    String defaultRoute = "",
  })  : _baseColor = baseColor,
        _themeMode = themeMode,
        _defaultRoute = defaultRoute;

  static Future<SettingsStorageNotifier> initialize() async {
    final theme = await _readSetting(appThemeMode);
    final color = await _readSetting(appColorSeed);
    final defaultRoute = await _readSetting(appDefaultRoute);
    return SettingsStorageNotifier(
      themeMode: theme == null
          ? ThemeMode.system
          : ThemeMode.values.asNameMap()[theme] ?? ThemeMode.system,
      baseColor: color == null
          ? ColorSeed.baseColor
          : ColorSeed.values.asNameMap()[color] ?? ColorSeed.baseColor,
      defaultRoute: defaultRoute ?? "",
    );
  }

  static Future<String?> _readSetting(String key) async {
    AppLogger.instance.d("Reading $key from shared_preferences");
    final preference = await SharedPreferencesAsync().getString(key);
    AppLogger.instance.d("Read $key as $preference from shared_preferences");
    return preference;
  }

  ThemeMode getTheme() => _themeMode;

  ColorSeed getBaseColor() => _baseColor;

  String getDefaultRoute() => _defaultRoute;

  Future<void> _setSetting(String key, String newSetting) async {
    AppLogger.instance.d("Writting newSetting as $key to shared_preferences");
    await SharedPreferencesAsync().setString(
      key,
      newSetting,
    );
    AppLogger.instance.d("Written newSetting as $key to shared_preferences");
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _setSetting(appThemeMode, themeMode.name);
  }

  Future<void> setColor(ColorSeed color) async {
    _baseColor = color;
    await _setSetting(appColorSeed, color.name);
  }

  Future<void> setDefaultRoute(String defaultRoute) async {
    _defaultRoute = defaultRoute;
    await _setSetting(appDefaultRoute, defaultRoute);
  }
}

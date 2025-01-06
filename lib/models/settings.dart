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

// Determines the way that hidden entries are encrypted
enum HiddenLockedMode {
  // unknown is only meant to be selected before initializing
  unknown('Invalid value'),

  none('Not Locked'),
  biometrics('Locked with biometrics'),
  pin("Locked using a pin");

  // TODO: Implement password encryption
  // password,

  const HiddenLockedMode(this.label);
  final String label;
}

class SettingsStorageNotifier with ChangeNotifier {
  ColorSeed _baseColor;
  ThemeMode _themeMode;
  HiddenLockedMode _hiddenLockedMode;

  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  SettingsStorageNotifier({
    ThemeMode themeMode = ThemeMode.system,
    ColorSeed baseColor = ColorSeed.baseColor,
    HiddenLockedMode hiddenLockedMode = HiddenLockedMode.unknown,
  })  : _baseColor = baseColor,
        _themeMode = themeMode,
        _hiddenLockedMode = hiddenLockedMode {
    init();
  }

  Future<void> writePin(String pin) async {
    AppLogger.instance.d("Writting $pin as $pinKey to shared_preferences");
    await SharedPreferencesAsync().setString(pinKey, pin);
    // TODO: Use flutter secure storage
    // await storage.write(key: pinKey, value: pin);
    AppLogger.instance.d("Written $pin as $pinKey to shared_preferences");
  }

  Future<String?> readPin() async {
    AppLogger.instance.d("Reading $pinKey from shared_preferences");
    final pin = await SharedPreferencesAsync().getString(pinKey);
    // final pin = await storage.read(key: pinKey);
    AppLogger.instance.d("Read $pin as $pinKey from shared_preferences");
    return pin;
  }

  Future<String?> _readSetting(String key) async {
    AppLogger.instance.d("Reading $key from shared_preferences");
    final preference = await asyncPrefs.getString(key);
    AppLogger.instance.d("Read $key as $preference from shared_preferences");
    return preference;
  }

  Future<void> _readThemeFromStorage() async {
    final preference = await _readSetting(appThemeMode);
    _themeMode = preference == null
        ? ThemeMode.system
        : ThemeMode.values.asNameMap()[preference] ?? ThemeMode.system;
  }

  Future<void> _readColorFromStorage() async {
    final preference = await _readSetting(appColorSeed);
    _baseColor = preference == null
        ? ColorSeed.baseColor
        : ColorSeed.values.asNameMap()[preference] ?? ColorSeed.baseColor;
  }

  Future<void> _readHiddenLockedMode() async {
    final preference = await _readSetting(hiddenLockedMode);
    _hiddenLockedMode = preference == null
        ? HiddenLockedMode.none
        : HiddenLockedMode.values.asNameMap()[preference] ??
            HiddenLockedMode.none;
  }

  void init() async {
    await Future.wait(
      [
        _readThemeFromStorage(),
        _readColorFromStorage(),
        _readHiddenLockedMode(),
      ],
    );
    notifyListeners();
  }

  HiddenLockedMode getHiddenLockedMode() => _hiddenLockedMode;

  ThemeMode getTheme() => _themeMode;

  ColorSeed getBaseColor() => _baseColor;

  Future<void> _setSetting(String key, String newSetting) async {
    AppLogger.instance.d("Writting newSetting as $key to shared_preferences");
    await asyncPrefs.setString(
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

  Future<void> setHiddenLockedMode(HiddenLockedMode newHiddenLockedMode) async {
    _hiddenLockedMode = newHiddenLockedMode;
    await _setSetting(hiddenLockedMode, newHiddenLockedMode.name);
  }
}

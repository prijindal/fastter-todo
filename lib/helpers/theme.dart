import 'package:flutter/material.dart';

ThemeData lightTheme(Color color) {
  final baseTheme = ThemeData(
    colorSchemeSeed: color,
    useMaterial3: true,
  );
  final lightTheme = baseTheme.copyWith(
    inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
      labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
      hintStyle: TextStyle(color: Colors.black54),
    ),
  );
  return lightTheme;
}

ThemeData darkTheme(Color color) {
  final baseTheme = ThemeData(
    colorSchemeSeed: color,
    brightness: Brightness.dark,
    useMaterial3: true,
  );
  final darkTheme = baseTheme.copyWith(
    inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
      labelStyle: TextStyle(color: Colors.white, fontSize: 16.0),
      hintStyle: TextStyle(color: Colors.white30),
    ),
  );
  return darkTheme;
}

class ThemeDataWrapper {
  final ThemeData theme;
  ThemeDataWrapper(this.theme);

  static ThemeDataWrapper of(BuildContext context) {
    return ThemeDataWrapper(Theme.of(context));
  }

  Color get dividerColor => Colors.grey.shade400;

  TextStyle get searchLabelStyle {
    return theme.inputDecorationTheme.labelStyle ?? TextStyle();
  }

  TextStyle get searchHintStyle =>
      theme.inputDecorationTheme.hintStyle ?? TextStyle();
}

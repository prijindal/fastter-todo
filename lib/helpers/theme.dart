import 'package:flutter/material.dart';

ThemeData primaryTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent,
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(Radius.circular(7.0)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
    border: const OutlineInputBorder(
      borderSide: BorderSide(),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      gapPadding: 2,
    ), // Replace code
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.purple.shade700,
);

ThemeData whiteTheme = ThemeData.lerp(
  ThemeData.dark(),
  ThemeData(primaryColor: Colors.white),
  1,
);

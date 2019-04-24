import 'package:flutter/material.dart';

ThemeData primaryTheme =
    ThemeData(primarySwatch: Colors.purple, accentColor: Colors.orangeAccent);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.purple.shade700,
);

ThemeData whiteTheme = ThemeData.lerp(
  ThemeData.dark(),
  ThemeData(primaryColor: Colors.white),
  1,
);

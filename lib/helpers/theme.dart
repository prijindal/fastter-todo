import 'package:flutter/material.dart';

ThemeData primaryTheme =
    ThemeData(primarySwatch: Colors.red, accentColor: Colors.orangeAccent);

ThemeData whiteTheme = ThemeData.lerp(
  ThemeData.dark(),
  ThemeData(primaryColor: Colors.white),
  1.0,
);

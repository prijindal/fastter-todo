import 'package:flutter/material.dart';

ThemeData primaryTheme = ThemeData(primarySwatch: Colors.deepOrange);

ThemeData whiteTheme =
    ThemeData.lerp(primaryTheme, ThemeData(primaryColor: Colors.white), 1.0);

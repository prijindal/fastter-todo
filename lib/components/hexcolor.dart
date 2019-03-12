import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    var _hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (_hexColor.length == 6) {
      _hexColor = 'FF$_hexColor';
    }
    return int.parse(_hexColor, radix: 16);
  }
}

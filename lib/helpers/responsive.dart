import 'package:flutter/material.dart';

enum ResponsiveBreakpoints { potrait, landscape }

ResponsiveBreakpoints getCurrentBreakpoint(BuildContext context) {
  final mediaQueryData = MediaQuery.of(context);
  if (mediaQueryData.orientation == Orientation.landscape &&
      mediaQueryData.size.width >= 720) {
    return ResponsiveBreakpoints.landscape;
  } else {
    return ResponsiveBreakpoints.potrait;
  }
}

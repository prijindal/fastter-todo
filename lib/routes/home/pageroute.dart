import 'dart:io';

import 'package:fastter_dart/fastter/fastter.dart';
import 'package:flutter/material.dart';
import '../../helpers/navigator.dart';
import '../../helpers/responsive.dart';

class HomePageRoute<T> extends MaterialPageRoute<T> {
  HomePageRoute({
    WidgetBuilder builder,
    bool fullscreenDialog = true,
  }) : super(
          builder: builder,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute ||
        Fastter.getInstance().socket == null ||
        Fastter.getInstance().socket.readyState != WebSocket.open) {
      return child;
    }
    if (getCurrentBreakpoint(context) == ResponsiveBreakpoints.landscape) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    } else {
      final theme = Theme.of(context).pageTransitionsTheme;
      return theme.buildTransitions<T>(
          this, context, animation, secondaryAnimation, child);
    }
  }
}

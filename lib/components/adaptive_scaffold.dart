import 'dart:math';

import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.appBar,
    this.drawer,
    required this.body,
    this.bottomSheet,
    this.floatingActionButton,
  });

  final PreferredSizeWidget appBar;
  final Widget? drawer;
  final Widget body;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;

  Widget _buildWithSideDrawer() {
    // In this view, drawer is displayed on the left hand side, and appbar is only on top of body
    return Scaffold(
      body: Row(
        children: [
          if (drawer != null) drawer!,
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                appBar,
                Flexible(
                  child: body,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomSheet: bottomSheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    if (width >= breakpoint && drawer != null) {
      return _buildWithSideDrawer();
    }
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: Center(
        child: SizedBox(
          width: min(width, breakpoint.toDouble()),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomSheet: bottomSheet,
    );
  }
}

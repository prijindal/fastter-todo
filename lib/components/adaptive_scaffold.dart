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
    this.secondaryBody,
  });

  final PreferredSizeWidget appBar;
  final Widget? drawer;
  final Widget body;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;
  final Widget? secondaryBody;

  Widget _buildBody() {
    return Row(
      children: [
        Expanded(
          child: body,
        ),
        if (secondaryBody != null) const VerticalDivider(width: 1),
        if (secondaryBody != null)
          Expanded(
            child: secondaryBody!,
          ),
      ],
    );
  }

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
                  child: _buildBody(),
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

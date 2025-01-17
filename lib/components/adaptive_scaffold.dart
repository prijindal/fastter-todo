import 'package:flutter/material.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.appBar,
    required this.drawer,
    required this.body,
    this.bottomSheet,
    this.floatingActionButton,
    this.secondaryBody,
  });

  final PreferredSizeWidget appBar;
  final Widget drawer;
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    if (width >= 1280) {
      return Scaffold(
        body: Row(
          children: [
            drawer,
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  appBar,
                  Flexible(child: _buildBody()),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: floatingActionButton,
        bottomSheet: bottomSheet,
      );
    }
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomSheet: bottomSheet,
    );
  }
}

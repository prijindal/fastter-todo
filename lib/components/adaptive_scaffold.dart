import 'package:flutter/material.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.appBar,
    required this.drawer,
    required this.body,
    this.bottomSheet,
    this.floatingActionButton,
  });

  final PreferredSizeWidget appBar;
  final Widget drawer;
  final Widget body;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    if (width >= 840) {
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
                  Flexible(child: body),
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

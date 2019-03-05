import 'package:flutter/material.dart';

import '../screens/inbox.dart';
import '../helpers/theme.dart';

class HomeContainer extends StatefulWidget {
  HomeContainer({
    @required this.onLogout,
  });
  final void Function() onLogout;

  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: primaryTheme,
      home: InboxScreen(),
    );
  }
}

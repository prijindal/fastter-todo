import 'package:flutter/material.dart';

import '../screens/inbox.dart';
import '../helpers/theme.dart';

class HomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: primaryTheme,
      home: InboxScreen(),
    );
  }
}

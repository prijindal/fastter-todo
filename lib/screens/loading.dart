import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          child: Center(
            child: Image.asset(
              'assets/icon/ic_launcher.png',
              width: 48,
            ),
          ),
        ),
      );
}

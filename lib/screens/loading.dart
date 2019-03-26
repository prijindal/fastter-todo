import 'dart:io';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Todo App'),
        ),
        body: Container(
          child: Center(
            child: (Platform.isAndroid || Platform.isIOS)
                ? Image.asset(
                    'assets/icon/ic_launcher.png',
                    width: 48,
                  )
                : const CircularProgressIndicator(),
          ),
        ),
      );
}

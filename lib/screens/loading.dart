import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Todo App'),
        ),
        body: Container(
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
}

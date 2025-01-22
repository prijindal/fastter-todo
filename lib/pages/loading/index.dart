import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
    this.onRestore,
  });

  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        actions: [
          IconButton(
            onPressed: onRestore,
            icon: Icon(Icons.restore),
          ),
        ],
      ),
      body: Center(
        child: Text("Loading"),
      ),
    );
  }
}

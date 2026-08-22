import 'package:material_ui/material_ui.dart';

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

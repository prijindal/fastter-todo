import 'package:material_ui/material_ui.dart';

import './app/app.dart';

void main() async {
  registerAllServices();
  runApp(
    const MyApp(),
  );
  WidgetsFlutterBinding.ensureInitialized();
}

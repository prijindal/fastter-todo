import 'package:flutter/material.dart';

import './app/app.dart';

void main() async {
  registerAllServices();
  runApp(
    const MyApp(),
  );
  WidgetsFlutterBinding.ensureInitialized();
}

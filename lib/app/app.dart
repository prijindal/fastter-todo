import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/logger.dart';
import '../helpers/theme.dart';
import '../models/local_state.dart';
import '../models/settings.dart';
import '../pages/settings/backup/firebase/firebase_sync.dart';
import '../router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsStorageNotifier>(
          create: (context) => SettingsStorageNotifier(),
        ),
        ChangeNotifierProvider<FirebaseSync>(
          create: (_) => FirebaseSync(),
        ),
        ChangeNotifierProvider<LocalStateNotifier>(
          create: (_) => LocalStateNotifier(),
        ),
      ],
      child: MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  MyMaterialApp({super.key});
  // This widget is the root of your application.
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    AppLogger.instance.d("Building MyApp");
    return Consumer<SettingsStorageNotifier>(
      builder: (context, settingsStorage, _) => MaterialApp.router(
        routerConfig: appRouter.config(),
        theme: lightTheme(settingsStorage.getBaseColor().color),
        darkTheme: darkTheme(settingsStorage.getBaseColor().color),
        themeMode: settingsStorage.getTheme(),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/dbio.dart';
import '../helpers/logger.dart';
import '../helpers/theme.dart';
import '../models/drift.dart';
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

class MyMaterialApp extends StatefulWidget {
  const MyMaterialApp({super.key});

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  // This widget is the root of your application.
  final appRouter = AppRouter();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    Timer(
      const Duration(seconds: 1),
      () => _initSync(),
    );
    Timer(
      const Duration(seconds: 3),
      () => _sync(),
    );
    _addWatcher();
    super.initState();
  }

  Future<void> _initSync() async {
    // This is just to initialize firebase and gdrive sync after firebase init is called
    Provider.of<FirebaseSync>(context, listen: false);
  }

  Future<void> _sync() async {
    await Future.wait([
      Provider.of<FirebaseSync>(context, listen: false)
          .sync(scaffoldMessengerKey.currentState, suppressErrors: false),
    ]);
  }

  Future<void> _addWatcher() async {
    final stream = MyDatabase.instance.tableUpdates();
    await for (final event in stream) {
      AppLogger.instance.d(event);
      await DatabaseIO.instance.updateLastUpdatedTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.instance.d("Building MyApp");
    return Consumer<SettingsStorageNotifier>(
      builder: (context, settingsStorage, _) => MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        routerConfig: appRouter.config(),
        theme: lightTheme(settingsStorage.getBaseColor().color),
        darkTheme: darkTheme(settingsStorage.getBaseColor().color),
        themeMode: settingsStorage.getTheme(),
      ),
    );
  }
}

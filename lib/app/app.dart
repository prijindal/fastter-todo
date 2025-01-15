import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/logger.dart';
import '../helpers/theme.dart';
import '../models/db_selector.dart';
import '../models/local_db_state.dart';
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
        ChangeNotifierProvider<DbSelector>(
          create: (context) => DbSelector(),
        ),
        ChangeNotifierProvider<SettingsStorageNotifier>(
          create: (context) => SettingsStorageNotifier(),
        ),
        ChangeNotifierProvider<LocalStateNotifier>(
          create: (_) => LocalStateNotifier(),
        ),
      ],
      child: MyMaterialAppWrapper(),
    );
  }
}

class MyMaterialAppWrapper extends StatelessWidget {
  const MyMaterialAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsStorageNotifier>(
      builder: (context, settingsStorage, _) {
        return Consumer<DbSelector>(
          builder: (context, dbSelector, _) {
            if (!dbSelector.isInitialized) {
              return MaterialApp(
                theme: lightTheme(settingsStorage.getBaseColor().color),
                darkTheme: darkTheme(settingsStorage.getBaseColor().color),
                themeMode: settingsStorage.getTheme(),
                home: Scaffold(
                  appBar: AppBar(
                    title: Text("Todos"),
                    actions: [
                      IconButton(
                          onPressed: () async {
                            await dbSelector.setLocal();
                            await dbSelector.initDb();
                          },
                          icon: Icon(Icons.restore)),
                    ],
                  ),
                  body: Center(
                    child: Text("Loading"),
                  ),
                ),
              );
            }
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<FirebaseSync>(
                  create: (context) => FirebaseSync(
                    () => dbSelector.io,
                  ),
                ),
                ChangeNotifierProvider<LocalDbState>(
                  create: (context) => LocalDbState(
                    dbSelector.database,
                  ),
                ),
              ],
              child: MyMaterialApp(
                key: Key(dbSelector.database.hashCode.toString()),
                settingsStorage: settingsStorage,
              ),
            );
          },
        );
      },
    );
  }
}

class MyMaterialApp extends StatefulWidget {
  const MyMaterialApp({
    super.key,
    required this.settingsStorage,
  });

  final SettingsStorageNotifier settingsStorage;

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  // This widget is the root of your application.
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
    super.initState();
  }

  Future<void> _initSync() async {
    // This is just to initialize firebase and gdrive sync after firebase init is called
    Provider.of<FirebaseSync>(context, listen: false);
  }

  Future<void> _sync() async {
    await Future.wait([
      Provider.of<FirebaseSync>(context, listen: false)
          .sync(scaffoldMessengerKey.currentState, suppressErrors: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.instance.d("Building MyApp");
    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: AppRouter.instance.config(),
      theme: lightTheme(widget.settingsStorage.getBaseColor().color),
      darkTheme: darkTheme(widget.settingsStorage.getBaseColor().color),
      themeMode: widget.settingsStorage.getTheme(),
    );
  }
}

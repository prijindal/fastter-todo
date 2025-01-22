import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/logger.dart';
import '../helpers/theme.dart';
import '../models/db_manager.dart';
import '../models/local_db_state.dart';
import '../models/local_state.dart';
import '../models/settings.dart';
import '../pages/loading/index.dart';
import '../router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DbManager>(
          create: (context) => DbManager(),
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
        return Consumer<DbManager>(
          builder: (context, dbSelector, _) {
            if (!dbSelector.isInitialized) {
              return MaterialApp(
                theme: lightTheme(settingsStorage.getBaseColor().color),
                darkTheme: darkTheme(settingsStorage.getBaseColor().color),
                themeMode: settingsStorage.getTheme(),
                home: LoadingScreen(
                  onRestore: () async {
                    await dbSelector.setLocal();
                    await dbSelector.initDb();
                  },
                ),
              );
            }
            return MultiProvider(
              providers: [
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

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({
    super.key,
    required this.settingsStorage,
  });

  final SettingsStorageNotifier settingsStorage;

  @override
  Widget build(BuildContext context) {
    AppLogger.instance.d("Building MyApp");
    return MaterialApp.router(
      routerConfig: AppRouter.instance.config(),
      theme: lightTheme(settingsStorage.getBaseColor().color),
      darkTheme: darkTheme(settingsStorage.getBaseColor().color),
      themeMode: settingsStorage.getTheme(),
    );
  }
}

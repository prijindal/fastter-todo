import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../helpers/logger.dart';
import '../helpers/theme.dart';
import '../models/db_manager.dart';
import '../models/local_db_state.dart';
import '../models/local_state.dart';
import '../models/settings.dart';
import '../pages/loading/index.dart';
import '../router/app_router.dart';

void registerAllServices() {
  GetIt.I.registerSingletonAsync<DbManager>(() => DbManager.autoInit());
  GetIt.I.registerSingleton<SettingsStorageNotifier>(SettingsStorageNotifier());
  GetIt.I.registerSingleton<LocalStateNotifier>(LocalStateNotifier());
  GetIt.I.registerSingletonAsync<LocalDbState>(() async => LocalDbState(),
      dependsOn: [DbManager]);
  GetIt.I.registerSingletonAsync<AppRouter>(() async => AppRouter(),
      dependsOn: [DbManager]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.I.allReady(),
      builder: (_, ready) => ready.hasData == false
          ? Material(
              child: Directionality(
              textDirection: TextDirection.ltr,
              child: Localizations(
                locale: const Locale('en', 'US'),
                delegates: const <LocalizationsDelegate<dynamic>>[
                  DefaultWidgetsLocalizations.delegate,
                  DefaultMaterialLocalizations.delegate,
                ],
                child: LoadingScreen(),
              ),
            ))
          : MultiProvider(
              providers: [
                ChangeNotifierProvider<LocalDbState>(
                  create: (context) => GetIt.I<LocalDbState>(),
                ),
              ],
              child: MyMaterialApp(),
            ),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({
    super.key,
  });

  SettingsStorageNotifier get settingsStorage =>
      GetIt.I<SettingsStorageNotifier>();
  DbManager get dbManager => GetIt.I<DbManager>();

  @override
  Widget build(BuildContext context) {
    AppLogger.instance.d("Building MyApp");
    return MaterialApp.router(
      routerConfig: GetIt.I<AppRouter>().config(),
      theme: lightTheme(settingsStorage.getBaseColor().color),
      darkTheme: darkTheme(settingsStorage.getBaseColor().color),
      themeMode: settingsStorage.getTheme(),
    );
  }
}

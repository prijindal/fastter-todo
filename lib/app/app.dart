import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:watch_it/watch_it.dart';

import '../db/backend_sync_configuration.dart';
import '../db/db_crud_operations.dart';
import '../helpers/breakpoints.dart';
import '../helpers/dbio.dart';
import '../helpers/logger.dart';
import '../helpers/theme.dart';
import '../helpers/todos_filters.dart';
import '../models/core.dart';
import '../models/local_db_state.dart';
import '../models/local_state.dart';
import '../models/settings.dart';
import '../pages/loading/index.dart';
import '../router/app_router.dart';

void registerAllServices() {
  GetIt.I.registerSingleton<SharedDatabase>(SharedDatabase.local());
  GetIt.I.registerSingletonAsync<SettingsStorageNotifier>(
      () => SettingsStorageNotifier.initialize());
  GetIt.I.registerSingleton<LocalStateNotifier>(LocalStateNotifier(
    todosView: isDesktop ? TodosView.grid : TodosView.list,
  ));
  GetIt.I.registerSingleton<LocalDbState>(
    LocalDbState(),
  );
  GetIt.I.registerSingleton<AppRouter>(AppRouter());
  GetIt.I.registerSingletonAsync<BackendSyncConfigurationService>(
      () => BackendSyncConfigurationService.init());
  GetIt.I.registerSingletonAsync<DbCrudOperations>(
    () async => DbCrudOperations(),
    dependsOn: [BackendSyncConfigurationService],
  );
  GetIt.I.registerSingletonAsync<DatabaseIO>(
    () async => DatabaseIO(),
    dependsOn: [DbCrudOperations],
  );
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
          : MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends WatchingStatefulWidget {
  const MyMaterialApp({
    super.key,
  });

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  LocalDbState get localDbState => GetIt.I<LocalDbState>();
  final QuickActions quickActions = const QuickActions();

  @override
  void initState() {
    _initQuickActions();
    super.initState();
    if (!kIsWeb) {
      final defaultRoute = GetIt.I<SettingsStorageNotifier>().getDefaultRoute();
      GetIt.I<AppRouter>().replacePath("/todos/?$defaultRoute");
    }
  }

  void _initQuickActions() {
    if (isMobile) {
      quickActions.initialize((shortcutType) {
        AppRouter appRouter = GetIt.I<AppRouter>();
        appRouter.navigatePath(shortcutType);
      });
      localDbState.addListener(() {
        final projects = localDbState.projects;
        final filters = [
          ...projects.map((project) => TodosFilters(projectFilter: project.id)),
          TodosFilters(projectFilter: "inbox")
        ];
        quickActions.setShortcutItems(
          filters
              .map((filter) => ShortcutItem(
                    type: "/todos/?${filter.queryString}",
                    localizedTitle: filter.createTitle(localDbState.projects),
                  ))
              .toList(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.instance.d("Building MyApp");
    final baseColor = watchPropertyValue(
      (SettingsStorageNotifier settingsStorageNotifier) =>
          settingsStorageNotifier.getBaseColor(),
    );
    final theme = watchPropertyValue(
      (SettingsStorageNotifier settingsStorageNotifier) =>
          settingsStorageNotifier.getTheme(),
    );
    return MaterialApp.router(
      routerConfig: GetIt.I<AppRouter>().config(),
      theme: lightTheme(baseColor.color),
      darkTheme: darkTheme(baseColor.color),
      themeMode: theme,
    );
  }
}

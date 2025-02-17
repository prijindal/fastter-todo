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
import '../router/app_router.dart';

void registerAllServices() {
  GetIt.I.registerLazySingleton<SharedDatabase>(() => SharedDatabase.local());
  GetIt.I.registerSingletonAsync<SettingsStorageNotifier>(
      () => SettingsStorageNotifier.initialize());
  GetIt.I.registerLazySingleton<LocalStateNotifier>(() => LocalStateNotifier(
        todosView: isDesktop ? TodosView.grid : TodosView.list,
      ));
  GetIt.I.registerLazySingleton<LocalDbState>(
    () => LocalDbState(),
  );
  GetIt.I.registerLazySingleton<AppRouter>(() => AppRouter());
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
  Widget build(BuildContext context) => const MyMaterialApp();
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
    final defaultRoute = GetIt.I<SettingsStorageNotifier>().getDefaultRoute();
    GetIt.I<AppRouter>().replaceNamed("/todos/?$defaultRoute");
  }

  void _initQuickActions() {
    if (isMobile) {
      quickActions.initialize((shortcutType) {
        AppRouter appRouter = GetIt.I<AppRouter>();
        appRouter.navigateNamed(shortcutType);
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

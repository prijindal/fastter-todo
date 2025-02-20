import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  RouteType get defaultRouteType =>
      RouteType.adaptive(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          path: "/todos",
          page: TodosRoute.page,
        ),
        AutoRoute(
          path: "/projects",
          page: ProjectsRoute.page,
        ),
        AutoRoute(
          path: "/newproject",
          page: NewProjectRoute.page,
        ),
        AutoRoute(
          path: "/project/:projectId",
          page: EditProjectRoute.page,
        ),
        AutoRoute(
          path: "/todo/:todoId",
          page: TodoRoute.page,
        ),
        AutoRoute(
          path: "/todochildren/:todoId",
          page: TodoChildrenRoute.page,
        ),
        AutoRoute(
          path: "/todocomments/:todoId",
          page: TodoCommentsRoute.page,
        ),
        AutoRoute(
          path: "/todoreminders/:todoId",
          page: TodoRemindersRoute.page,
        ),
        AutoRoute(
          path: "/search",
          page: SearchRoute.page,
        ),
        CustomRoute<void>(
          path: "/settings",
          page: SettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute<void>(
          path: "/settings/backup",
          page: BackupSettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute<void>(
          path: "/settings/backend",
          page: BackendSettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute<void>(
          path: "/settings/help",
          page: HelpSettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute<void>(
          path: "/settings/permissions",
          page: PermissionsSettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute<void>(
          path: "/settings/notifications",
          page: NotificationsSettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        CustomRoute<void>(
          path: "/settings/styling",
          page: StylingSettingsRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
      ];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i16;
import 'package:fastter_todo/pages/home/index.dart' as _i6;
import 'package:fastter_todo/pages/newproject/index.dart' as _i7;
import 'package:fastter_todo/pages/project/index.dart' as _i8;
import 'package:fastter_todo/pages/projects/index.dart' as _i9;
import 'package:fastter_todo/pages/settings/backup/firebase/firebase_login.dart'
    as _i3;
import 'package:fastter_todo/pages/settings/backup/firebase/firebase_profile.dart'
    as _i4;
import 'package:fastter_todo/pages/settings/backup/firebase/firebase_screen.dart'
    as _i2;
import 'package:fastter_todo/pages/settings/backup/index.dart' as _i1;
import 'package:fastter_todo/pages/settings/help.dart' as _i5;
import 'package:fastter_todo/pages/settings/index.dart' as _i11;
import 'package:fastter_todo/pages/settings/security.dart' as _i10;
import 'package:fastter_todo/pages/settings/styling.dart' as _i12;
import 'package:fastter_todo/pages/todo/index.dart' as _i15;
import 'package:fastter_todo/pages/todocomments/index.dart' as _i13;
import 'package:fastter_todo/pages/todoreminders/index.dart' as _i14;
import 'package:flutter/material.dart' as _i17;

/// generated route for
/// [_i1.BackupSettingsScreen]
class BackupSettingsRoute extends _i16.PageRouteInfo<void> {
  const BackupSettingsRoute({List<_i16.PageRouteInfo>? children})
      : super(
          BackupSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'BackupSettingsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i1.BackupSettingsScreen();
    },
  );
}

/// generated route for
/// [_i2.FirebaseBackupScreen]
class FirebaseBackupRoute extends _i16.PageRouteInfo<void> {
  const FirebaseBackupRoute({List<_i16.PageRouteInfo>? children})
      : super(
          FirebaseBackupRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirebaseBackupRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i2.FirebaseBackupScreen();
    },
  );
}

/// generated route for
/// [_i3.FirebaseLoginScreen]
class FirebaseLoginRoute extends _i16.PageRouteInfo<void> {
  const FirebaseLoginRoute({List<_i16.PageRouteInfo>? children})
      : super(
          FirebaseLoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirebaseLoginRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i3.FirebaseLoginScreen();
    },
  );
}

/// generated route for
/// [_i4.FirebaseProfileScreen]
class FirebaseProfileRoute extends _i16.PageRouteInfo<void> {
  const FirebaseProfileRoute({List<_i16.PageRouteInfo>? children})
      : super(
          FirebaseProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirebaseProfileRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i4.FirebaseProfileScreen();
    },
  );
}

/// generated route for
/// [_i5.HelpSettingsScreen]
class HelpSettingsRoute extends _i16.PageRouteInfo<void> {
  const HelpSettingsRoute({List<_i16.PageRouteInfo>? children})
      : super(
          HelpSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'HelpSettingsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i5.HelpSettingsScreen();
    },
  );
}

/// generated route for
/// [_i6.HomeScreen]
class HomeRoute extends _i16.PageRouteInfo<void> {
  const HomeRoute({List<_i16.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i6.HomeScreen();
    },
  );
}

/// generated route for
/// [_i7.NewProjectScreen]
class NewProjectRoute extends _i16.PageRouteInfo<void> {
  const NewProjectRoute({List<_i16.PageRouteInfo>? children})
      : super(
          NewProjectRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewProjectRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i7.NewProjectScreen();
    },
  );
}

/// generated route for
/// [_i8.ProjectScreen]
class ProjectRoute extends _i16.PageRouteInfo<ProjectRouteArgs> {
  ProjectRoute({
    _i17.Key? key,
    required String projectFilter,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          ProjectRoute.name,
          args: ProjectRouteArgs(
            key: key,
            projectFilter: projectFilter,
          ),
          rawPathParams: {'projectFilter': projectFilter},
          initialChildren: children,
        );

  static const String name = 'ProjectRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ProjectRouteArgs>(
          orElse: () => ProjectRouteArgs(
              projectFilter: pathParams.getString('projectFilter')));
      return _i8.ProjectScreen(
        key: args.key,
        projectFilter: args.projectFilter,
      );
    },
  );
}

class ProjectRouteArgs {
  const ProjectRouteArgs({
    this.key,
    required this.projectFilter,
  });

  final _i17.Key? key;

  final String projectFilter;

  @override
  String toString() {
    return 'ProjectRouteArgs{key: $key, projectFilter: $projectFilter}';
  }
}

/// generated route for
/// [_i9.ProjectsScreen]
class ProjectsRoute extends _i16.PageRouteInfo<void> {
  const ProjectsRoute({List<_i16.PageRouteInfo>? children})
      : super(
          ProjectsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i9.ProjectsScreen();
    },
  );
}

/// generated route for
/// [_i10.SecuritySettingsScreen]
class SecuritySettingsRoute extends _i16.PageRouteInfo<void> {
  const SecuritySettingsRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SecuritySettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecuritySettingsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i10.SecuritySettingsScreen();
    },
  );
}

/// generated route for
/// [_i11.SettingsScreen]
class SettingsRoute extends _i16.PageRouteInfo<void> {
  const SettingsRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i11.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i12.StylingSettingsScreen]
class StylingSettingsRoute extends _i16.PageRouteInfo<void> {
  const StylingSettingsRoute({List<_i16.PageRouteInfo>? children})
      : super(
          StylingSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'StylingSettingsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i12.StylingSettingsScreen();
    },
  );
}

/// generated route for
/// [_i13.TodoCommentsScreen]
class TodoCommentsRoute extends _i16.PageRouteInfo<TodoCommentsRouteArgs> {
  TodoCommentsRoute({
    _i17.Key? key,
    required String todoId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          TodoCommentsRoute.name,
          args: TodoCommentsRouteArgs(
            key: key,
            todoId: todoId,
          ),
          rawPathParams: {'todoId': todoId},
          initialChildren: children,
        );

  static const String name = 'TodoCommentsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TodoCommentsRouteArgs>(
          orElse: () =>
              TodoCommentsRouteArgs(todoId: pathParams.getString('todoId')));
      return _i13.TodoCommentsScreen(
        key: args.key,
        todoId: args.todoId,
      );
    },
  );
}

class TodoCommentsRouteArgs {
  const TodoCommentsRouteArgs({
    this.key,
    required this.todoId,
  });

  final _i17.Key? key;

  final String todoId;

  @override
  String toString() {
    return 'TodoCommentsRouteArgs{key: $key, todoId: $todoId}';
  }
}

/// generated route for
/// [_i14.TodoRemindersScreen]
class TodoRemindersRoute extends _i16.PageRouteInfo<TodoRemindersRouteArgs> {
  TodoRemindersRoute({
    _i17.Key? key,
    required String todoId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          TodoRemindersRoute.name,
          args: TodoRemindersRouteArgs(
            key: key,
            todoId: todoId,
          ),
          rawPathParams: {'todoId': todoId},
          initialChildren: children,
        );

  static const String name = 'TodoRemindersRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TodoRemindersRouteArgs>(
          orElse: () =>
              TodoRemindersRouteArgs(todoId: pathParams.getString('todoId')));
      return _i14.TodoRemindersScreen(
        key: args.key,
        todoId: args.todoId,
      );
    },
  );
}

class TodoRemindersRouteArgs {
  const TodoRemindersRouteArgs({
    this.key,
    required this.todoId,
  });

  final _i17.Key? key;

  final String todoId;

  @override
  String toString() {
    return 'TodoRemindersRouteArgs{key: $key, todoId: $todoId}';
  }
}

/// generated route for
/// [_i15.TodoScreen]
class TodoRoute extends _i16.PageRouteInfo<TodoRouteArgs> {
  TodoRoute({
    _i17.Key? key,
    required String todoId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          TodoRoute.name,
          args: TodoRouteArgs(
            key: key,
            todoId: todoId,
          ),
          rawPathParams: {'todoId': todoId},
          initialChildren: children,
        );

  static const String name = 'TodoRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TodoRouteArgs>(
          orElse: () => TodoRouteArgs(todoId: pathParams.getString('todoId')));
      return _i15.TodoScreen(
        key: args.key,
        todoId: args.todoId,
      );
    },
  );
}

class TodoRouteArgs {
  const TodoRouteArgs({
    this.key,
    required this.todoId,
  });

  final _i17.Key? key;

  final String todoId;

  @override
  String toString() {
    return 'TodoRouteArgs{key: $key, todoId: $todoId}';
  }
}

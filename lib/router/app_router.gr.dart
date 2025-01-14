// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:fastter_todo/pages/project/edit.dart' as _i3;
import 'package:fastter_todo/pages/project/new.dart' as _i8;
import 'package:fastter_todo/pages/projects/index.dart' as _i9;
import 'package:fastter_todo/pages/settings/backend/index.dart' as _i1;
import 'package:fastter_todo/pages/settings/backup/firebase/firebase_login.dart'
    as _i5;
import 'package:fastter_todo/pages/settings/backup/firebase/firebase_profile.dart'
    as _i6;
import 'package:fastter_todo/pages/settings/backup/firebase/firebase_screen.dart'
    as _i4;
import 'package:fastter_todo/pages/settings/backup/index.dart' as _i2;
import 'package:fastter_todo/pages/settings/help.dart' as _i7;
import 'package:fastter_todo/pages/settings/index.dart' as _i11;
import 'package:fastter_todo/pages/settings/security.dart' as _i10;
import 'package:fastter_todo/pages/settings/styling.dart' as _i12;
import 'package:fastter_todo/pages/todo/index.dart' as _i15;
import 'package:fastter_todo/pages/todocomments/index.dart' as _i13;
import 'package:fastter_todo/pages/todoreminders/index.dart' as _i14;
import 'package:fastter_todo/pages/todos/index.dart' as _i16;
import 'package:flutter/material.dart' as _i18;

/// generated route for
/// [_i1.BackendSettingsScreen]
class BackendSettingsRoute extends _i17.PageRouteInfo<void> {
  const BackendSettingsRoute({List<_i17.PageRouteInfo>? children})
    : super(BackendSettingsRoute.name, initialChildren: children);

  static const String name = 'BackendSettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i1.BackendSettingsScreen();
    },
  );
}

/// generated route for
/// [_i2.BackupSettingsScreen]
class BackupSettingsRoute extends _i17.PageRouteInfo<void> {
  const BackupSettingsRoute({List<_i17.PageRouteInfo>? children})
    : super(BackupSettingsRoute.name, initialChildren: children);

  static const String name = 'BackupSettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i2.BackupSettingsScreen();
    },
  );
}

/// generated route for
/// [_i3.EditProjectScreen]
class EditProjectRoute extends _i17.PageRouteInfo<EditProjectRouteArgs> {
  EditProjectRoute({
    _i18.Key? key,
    required String projectId,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         EditProjectRoute.name,
         args: EditProjectRouteArgs(key: key, projectId: projectId),
         rawPathParams: {'projectId': projectId},
         initialChildren: children,
       );

  static const String name = 'EditProjectRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<EditProjectRouteArgs>(
        orElse:
            () => EditProjectRouteArgs(
              projectId: pathParams.getString('projectId'),
            ),
      );
      return _i3.EditProjectScreen(key: args.key, projectId: args.projectId);
    },
  );
}

class EditProjectRouteArgs {
  const EditProjectRouteArgs({this.key, required this.projectId});

  final _i18.Key? key;

  final String projectId;

  @override
  String toString() {
    return 'EditProjectRouteArgs{key: $key, projectId: $projectId}';
  }
}

/// generated route for
/// [_i4.FirebaseBackupScreen]
class FirebaseBackupRoute extends _i17.PageRouteInfo<void> {
  const FirebaseBackupRoute({List<_i17.PageRouteInfo>? children})
    : super(FirebaseBackupRoute.name, initialChildren: children);

  static const String name = 'FirebaseBackupRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i4.FirebaseBackupScreen();
    },
  );
}

/// generated route for
/// [_i5.FirebaseLoginScreen]
class FirebaseLoginRoute extends _i17.PageRouteInfo<void> {
  const FirebaseLoginRoute({List<_i17.PageRouteInfo>? children})
    : super(FirebaseLoginRoute.name, initialChildren: children);

  static const String name = 'FirebaseLoginRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i5.FirebaseLoginScreen();
    },
  );
}

/// generated route for
/// [_i6.FirebaseProfileScreen]
class FirebaseProfileRoute extends _i17.PageRouteInfo<void> {
  const FirebaseProfileRoute({List<_i17.PageRouteInfo>? children})
    : super(FirebaseProfileRoute.name, initialChildren: children);

  static const String name = 'FirebaseProfileRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i6.FirebaseProfileScreen();
    },
  );
}

/// generated route for
/// [_i7.HelpSettingsScreen]
class HelpSettingsRoute extends _i17.PageRouteInfo<void> {
  const HelpSettingsRoute({List<_i17.PageRouteInfo>? children})
    : super(HelpSettingsRoute.name, initialChildren: children);

  static const String name = 'HelpSettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i7.HelpSettingsScreen();
    },
  );
}

/// generated route for
/// [_i8.NewProjectScreen]
class NewProjectRoute extends _i17.PageRouteInfo<void> {
  const NewProjectRoute({List<_i17.PageRouteInfo>? children})
    : super(NewProjectRoute.name, initialChildren: children);

  static const String name = 'NewProjectRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i8.NewProjectScreen();
    },
  );
}

/// generated route for
/// [_i9.ProjectsScreen]
class ProjectsRoute extends _i17.PageRouteInfo<void> {
  const ProjectsRoute({List<_i17.PageRouteInfo>? children})
    : super(ProjectsRoute.name, initialChildren: children);

  static const String name = 'ProjectsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i9.ProjectsScreen();
    },
  );
}

/// generated route for
/// [_i10.SecuritySettingsScreen]
class SecuritySettingsRoute extends _i17.PageRouteInfo<void> {
  const SecuritySettingsRoute({List<_i17.PageRouteInfo>? children})
    : super(SecuritySettingsRoute.name, initialChildren: children);

  static const String name = 'SecuritySettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i10.SecuritySettingsScreen();
    },
  );
}

/// generated route for
/// [_i11.SettingsScreen]
class SettingsRoute extends _i17.PageRouteInfo<void> {
  const SettingsRoute({List<_i17.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i11.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i12.StylingSettingsScreen]
class StylingSettingsRoute extends _i17.PageRouteInfo<void> {
  const StylingSettingsRoute({List<_i17.PageRouteInfo>? children})
    : super(StylingSettingsRoute.name, initialChildren: children);

  static const String name = 'StylingSettingsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i12.StylingSettingsScreen();
    },
  );
}

/// generated route for
/// [_i13.TodoCommentsScreen]
class TodoCommentsRoute extends _i17.PageRouteInfo<TodoCommentsRouteArgs> {
  TodoCommentsRoute({
    _i18.Key? key,
    required String todoId,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         TodoCommentsRoute.name,
         args: TodoCommentsRouteArgs(key: key, todoId: todoId),
         rawPathParams: {'todoId': todoId},
         initialChildren: children,
       );

  static const String name = 'TodoCommentsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TodoCommentsRouteArgs>(
        orElse:
            () => TodoCommentsRouteArgs(todoId: pathParams.getString('todoId')),
      );
      return _i13.TodoCommentsScreen(key: args.key, todoId: args.todoId);
    },
  );
}

class TodoCommentsRouteArgs {
  const TodoCommentsRouteArgs({this.key, required this.todoId});

  final _i18.Key? key;

  final String todoId;

  @override
  String toString() {
    return 'TodoCommentsRouteArgs{key: $key, todoId: $todoId}';
  }
}

/// generated route for
/// [_i14.TodoRemindersScreen]
class TodoRemindersRoute extends _i17.PageRouteInfo<TodoRemindersRouteArgs> {
  TodoRemindersRoute({
    _i18.Key? key,
    required String todoId,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         TodoRemindersRoute.name,
         args: TodoRemindersRouteArgs(key: key, todoId: todoId),
         rawPathParams: {'todoId': todoId},
         initialChildren: children,
       );

  static const String name = 'TodoRemindersRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TodoRemindersRouteArgs>(
        orElse:
            () =>
                TodoRemindersRouteArgs(todoId: pathParams.getString('todoId')),
      );
      return _i14.TodoRemindersScreen(key: args.key, todoId: args.todoId);
    },
  );
}

class TodoRemindersRouteArgs {
  const TodoRemindersRouteArgs({this.key, required this.todoId});

  final _i18.Key? key;

  final String todoId;

  @override
  String toString() {
    return 'TodoRemindersRouteArgs{key: $key, todoId: $todoId}';
  }
}

/// generated route for
/// [_i15.TodoScreen]
class TodoRoute extends _i17.PageRouteInfo<TodoRouteArgs> {
  TodoRoute({
    _i18.Key? key,
    required String todoId,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         TodoRoute.name,
         args: TodoRouteArgs(key: key, todoId: todoId),
         rawPathParams: {'todoId': todoId},
         initialChildren: children,
       );

  static const String name = 'TodoRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TodoRouteArgs>(
        orElse: () => TodoRouteArgs(todoId: pathParams.getString('todoId')),
      );
      return _i15.TodoScreen(key: args.key, todoId: args.todoId);
    },
  );
}

class TodoRouteArgs {
  const TodoRouteArgs({this.key, required this.todoId});

  final _i18.Key? key;

  final String todoId;

  @override
  String toString() {
    return 'TodoRouteArgs{key: $key, todoId: $todoId}';
  }
}

/// generated route for
/// [_i16.TodosScreen]
class TodosRoute extends _i17.PageRouteInfo<TodosRouteArgs> {
  TodosRoute({
    _i18.Key? key,
    String? projectFilter,
    String? tagFilter,
    int? daysAhead,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         TodosRoute.name,
         args: TodosRouteArgs(
           key: key,
           projectFilter: projectFilter,
           tagFilter: tagFilter,
           daysAhead: daysAhead,
         ),
         rawQueryParams: {
           'projectFilter': projectFilter,
           'tagFilter': tagFilter,
           'daysAhead': daysAhead,
         },
         initialChildren: children,
       );

  static const String name = 'TodosRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<TodosRouteArgs>(
        orElse:
            () => TodosRouteArgs(
              projectFilter: queryParams.optString('projectFilter'),
              tagFilter: queryParams.optString('tagFilter'),
              daysAhead: queryParams.optInt('daysAhead'),
            ),
      );
      return _i16.TodosScreen(
        key: args.key,
        projectFilter: args.projectFilter,
        tagFilter: args.tagFilter,
        daysAhead: args.daysAhead,
      );
    },
  );
}

class TodosRouteArgs {
  const TodosRouteArgs({
    this.key,
    this.projectFilter,
    this.tagFilter,
    this.daysAhead,
  });

  final _i18.Key? key;

  final String? projectFilter;

  final String? tagFilter;

  final int? daysAhead;

  @override
  String toString() {
    return 'TodosRouteArgs{key: $key, projectFilter: $projectFilter, tagFilter: $tagFilter, daysAhead: $daysAhead}';
  }
}

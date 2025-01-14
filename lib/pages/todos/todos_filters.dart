import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/core.dart';
import '../../models/db_selector.dart';

void openSettings(BuildContext context) {
  AutoRouter.of(context).pushNamed("/settings");
}

enum AppBarActions {
  settings(
    onPressed: openSettings,
    icon: Icon(
      Icons.settings,
      size: 26.0,
    ),
  );

  final void Function(BuildContext context) onPressed;
  final Icon icon;

  const AppBarActions({
    required this.icon,
    required this.onPressed,
  });
}

class TodosFilters {
  final String? projectFilter;
  final String? tagFilter;
  final int? daysAhead; // Due Date less than or equal to

  const TodosFilters({
    this.projectFilter,
    this.tagFilter,
    this.daysAhead,
  });

  Stream<List<TodoData>> createStream(BuildContext context) {
    var manager = Provider.of<DbSelector>(context, listen: false)
        .database
        .managers
        .todo
        .filter((f) => f.id.not.isNull());
    manager = manager.orderBy(
        (o) => o.priority.desc() & o.completed.asc() & o.dueDate.asc());
    if (projectFilter != null) {
      if (projectFilter == "inbox") {
        manager = manager.filter((f) => f.project.isNull());
      } else {
        manager = manager.filter((f) => f.project.equals(projectFilter));
      }
    }
    if (tagFilter != null) {
      manager = manager.filter((f) => f.tags.column.contains(tagFilter!));
    }
    if (daysAhead != null) {
      manager = manager.filter((f) =>
          f.dueDate.isBefore(DateTime.now().add(Duration(days: daysAhead!))));
    }
    return manager.watch();
  }

  FutureOr<String> createTitle(BuildContext context) {
    if (projectFilter == null && tagFilter == null && daysAhead == null) {
      return "All Todos";
    }
    if (daysAhead != null) {
      if (daysAhead == 1) {
        return "Today";
      }
      return "$daysAhead days";
    }
    if (tagFilter != null) {
      return tagFilter!;
    }
    if (projectFilter != null) {
      if (projectFilter == "inbox") {
        return "Inbox";
      } else {
        return Future(() async {
          // ignore: use_build_context_synchronously
          final project = await Provider.of<DbSelector>(context, listen: false)
              .database
              .managers
              .project
              .filter((f) => f.id.equals(projectFilter))
              .getSingle();
          return project.title;
        });
      }
    }
    return "Todos";
  }

  String get queryString {
    final parts = <String>[];
    if (projectFilter != null) {
      parts.add("projectFilter=$projectFilter");
    }
    if (tagFilter != null) {
      parts.add("tagFilter=$tagFilter");
    }
    if (daysAhead != null) {
      parts.add("daysAhead=$daysAhead");
    }
    return parts.join("&");
  }

  List<AppBarActions> get actions {
    return [AppBarActions.settings];
  }

  @override
  int get hashCode =>
      projectFilter.hashCode ^ tagFilter.hashCode ^ daysAhead.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TodosFilters &&
        other.projectFilter == projectFilter &&
        other.tagFilter == tagFilter &&
        other.daysAhead == daysAhead;
  }
}

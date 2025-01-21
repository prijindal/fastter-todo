import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/core.dart';
import '../models/local_db_state.dart';

class AppBarActions {
  final void Function(BuildContext context) onPressed;
  final Widget icon;

  const AppBarActions({
    required this.icon,
    required this.onPressed,
  });

  factory AppBarActions.settings() {
    return AppBarActions(
      icon: Icon(Icons.settings),
      onPressed: (context) => AutoRouter.of(context).pushNamed("/settings"),
    );
  }

  factory AppBarActions.editProject(String projectId) {
    return AppBarActions(
      icon: Icon(Icons.edit),
      onPressed: (context) =>
          AutoRouter.of(context).pushNamed("/project/$projectId"),
    );
  }

  factory AppBarActions.forceRefresh() {
    return AppBarActions(
      icon: Selector<LocalDbState, bool>(
        selector: (_, state) => state.isRefreshing || !state.isInitialized,
        builder: (context, isRefreshing, _) =>
            isRefreshing ? Icon(Icons.sync) : Icon(Icons.refresh),
      ),
      onPressed: (context) =>
          Provider.of<LocalDbState>(context, listen: false).refresh(),
    );
  }
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

  List<TodoData> filtered(List<TodoData> initialTodos) {
    Iterable<TodoData> todos = initialTodos.toList();
    todos = todos.where((a) => a.parent == null);
    // TODO: Compare, sorting order: priority, completed, dueDate
    if (projectFilter != null) {
      if (projectFilter == "inbox") {
        todos = todos.where((t) => t.project == null);
      } else {
        todos = todos.where((t) => t.project == projectFilter);
      }
    }
    if (tagFilter != null) {
      todos = todos.where((t) => t.tags.contains(tagFilter));
    }
    if (daysAhead != null) {
      todos = todos
          .where(
            (t) =>
                t.dueDate != null &&
                t.dueDate!.compareTo(
                      DateTime.now().add(Duration(days: daysAhead!)),
                    ) <=
                    0,
          )
          .toList();
    }
    return todos.toList();
  }

  String createTitle(BuildContext context) {
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
        // ignore: use_build_context_synchronously
        final project = Provider.of<LocalDbState>(context, listen: false)
            .projects
            .where((f) => f.id == projectFilter)
            .firstOrNull;
        if (project != null) {
          return project.title;
        }
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
    final actions = <AppBarActions>[];
    if (projectFilter != null && projectFilter != "inbox") {
      actions.add(AppBarActions.editProject(projectFilter!));
    }
    actions.add(AppBarActions.forceRefresh());
    actions.add(AppBarActions.settings());
    return actions;
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

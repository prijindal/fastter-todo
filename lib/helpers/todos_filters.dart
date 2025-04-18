import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/core.dart';
import '../models/local_db_state.dart';
import '../models/local_state.dart';
import '../pages/todos/app_bars/app_bar_with_actions.dart';
import '../pages/todos/projectdeletiondialog.dart';

class AppBarActions {
  static AppBarAction toggleView() {
    return AppBarAction(
      icon: Icon(Icons.list),
      title: "Toggle View",
      onPressed: (context) {
        final localStateNotifier = GetIt.I<LocalStateNotifier>();
        localStateNotifier.setTodosView(
          localStateNotifier.todosView == TodosView.list
              ? TodosView.grid
              : TodosView.list,
        );
      },
    );
  }

  static AppBarAction settings() {
    return AppBarAction(
      icon: Icon(Icons.settings),
      title: "Settings",
      onPressed: (context) => AutoRouter.of(context).pushPath("/settings"),
    );
  }

  static AppBarAction editProject(String projectId) {
    return AppBarAction(
      icon: Icon(Icons.edit),
      title: "Edit Project",
      onPressed: (context) =>
          AutoRouter.of(context).pushPath("/project/$projectId"),
    );
  }

  static AppBarAction deleteProject(String projectId) {
    return AppBarAction(
      icon: Icon(Icons.delete),
      title: "Delete Project",
      onPressed: (context) async {
        final deleted = await showProjectDeletionDialog(
          context,
          GetIt.I<LocalDbState>()
              .projects
              .singleWhere((f) => f.id == projectId),
        );
        if (deleted) {
          // ignore: use_build_context_synchronously
          AutoRouter.of(context).navigatePath("/todos");
        }
      },
    );
  }

  static AppBarAction search() {
    return AppBarAction(
      icon: Icon(Icons.search),
      title: "Search",
      onPressed: (context) => AutoRouter.of(context).pushPath("/search"),
    );
  }

  static AppBarAction forceRefresh() {
    return AppBarAction(
      // TODO: Display refreshing status
      icon: Icon(Icons.refresh),
      title: "Refresh",
      onPressed: (context) => GetIt.I<LocalDbState>().refresh(),
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

  String createTitle(List<ProjectData> projects) {
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
        final project =
            projects.where((f) => f.id == projectFilter).firstOrNull;
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

  List<AppBarAction> get actions {
    final actions = <AppBarAction>[];
    actions.add(AppBarActions.search());
    if (projectFilter != null && projectFilter != "inbox") {
      actions.add(AppBarActions.editProject(projectFilter!));
      actions.add(AppBarActions.deleteProject(projectFilter!));
    }
    actions.add(AppBarActions.toggleView());
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

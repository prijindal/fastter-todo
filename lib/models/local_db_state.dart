import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'core.dart';
import 'local_notifications_manager.dart';

class LocalDbState extends ChangeNotifier {
  SharedDatabase get db => GetIt.I<SharedDatabase>();
  final LocalNotificationsManager localNotificationsManager =
      LocalNotificationsManager();

  List<StreamSubscription<List<dynamic>>> _subscriptions = [];

  final Map<String, List<drift.DataClass>> _localState = {};

  List<TodoData> get todos =>
      List.unmodifiable((_localState["todo"] as List<TodoData>?) ?? []);
  List<ProjectData> get projects =>
      List.unmodifiable((_localState["project"] as List<ProjectData>?) ?? []);
  List<CommentData> get comments =>
      List.unmodifiable((_localState["comment"] as List<CommentData>?) ?? []);
  List<ReminderData> get reminders =>
      List.unmodifiable((_localState["reminder"] as List<ReminderData>?) ?? []);

  final Map<String, bool> _initialized = {
    "todo": false,
    "project": false,
    "comment": false,
    "reminder": false,
  };

  bool _isRefreshing = false;

  bool get isRefreshing => _isRefreshing;

  bool get isTodosInitialized =>
      _localState["todo"] != null || (_initialized["todo"] ?? false);

  bool get isInitialized =>
      (_localState["todo"] != null || (_initialized["todo"] ?? false)) &&
      (_localState["project"] != null || (_initialized["project"] ?? false)) &&
      (_localState["comment"] != null || (_initialized["comment"] ?? false)) &&
      (_localState["reminder"] != null || (_initialized["reminder"] ?? false));

  LocalDbState() {
    // Local state is first initialized with local storage, this makes sure that when we first do init, we have some data on ui
    // This is only really useful when our sqlite db is a remote one
    initFromDb();
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  Future<void> syncReminders() async {
    if (reminders.isNotEmpty) {
      final status = await localNotificationsManager.register();
      if (status) {
        await localNotificationsManager.syncReminders(reminders, todos);
      }
    }
  }

  Future<void> refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    notifyListeners();
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    await initFromDb();
    await syncReminders();
    _isRefreshing = false;
    notifyListeners();
  }

  Future<void> onChange<T extends drift.DataClass>(
    drift.RootTableManager<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic,
            dynamic, dynamic, dynamic, T, dynamic>
        manager,
    String table,
  ) async {
    final values = await manager.get();
    _localState[table] = values.toList();
    _initialized[table] = true;
    notifyListeners();
  }

  Future<StreamSubscription<List<dynamic>>?>
      _refreshAndInitTable<T extends drift.DataClass>(
    drift.RootTableManager<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic,
            dynamic, dynamic, dynamic, T, dynamic>
        manager,
    String table,
  ) async {
    await onChange(manager, table);
    return manager.watch().listen((_) async {
      await onChange(manager, table);
    });
  }

  Future<void> initFromDb() async {
    final subscriptions = await Future.wait([
      _refreshAndInitTable(db.managers.todo, "todo"),
      _refreshAndInitTable(db.managers.project, "project"),
      _refreshAndInitTable(db.managers.reminder, "reminder"),
      _refreshAndInitTable(db.managers.comment, "comment"),
    ]);
    _subscriptions = subscriptions.where((a) => a != null).toList().cast();
  }

  List<String> get allTags {
    final List<String> tags = [];
    for (var todo in todos) {
      for (var tag in todo.tags) {
        if (!tags.contains(tag)) {
          tags.add(tag);
        }
      }
    }
    return tags;
  }

  // Get all possible pipelines of a project id
  List<String> getProjectPipelines(String? id) {
    var status = <String>[];
    if (id == null) {
      status = [defaultPipeline];
    } else {
      final project = projects.where((element) => element.id == id).firstOrNull;
      if (project == null) {
        return [defaultPipeline];
      }

      status = project.pipelines;
    }
    return status;
  }

  List<String> getTodosTags(List<String> todoId) {
    final selectedTodos = todos.where((element) => todoId.contains(element.id));
    final List<String> tags = [];
    for (var todo in selectedTodos) {
      for (var tag in todo.tags) {
        if (!tags.contains(tag)) {
          tags.add(tag);
        }
      }
    }
    return tags;
  }

  List<String> getTodoTag(String id) {
    final todo = todos.where((element) => element.id == id).firstOrNull;
    return todo?.tags ?? [];
  }

  String formTextFromTodos(List<String> ids) {
    final todos = this.todos.where((todo) => ids.contains(todo.id));
    return todos.map((a) {
      var t = "";
      if (a.completed) {
        t += "[x]";
      } else {
        t += "[ ]";
      }
      t += " ${a.title}";
      return t;
    }).join('\n');
  }

  List<ReminderData> getTodoReminders(String id, [bool onlyPending = false]) {
    if (onlyPending) {
      final now = DateTime.now();
      return reminders
          .where((element) =>
              element.todo == id && element.time.compareTo(now) >= 0)
          .toList();
    }
    return reminders.where((element) => element.todo == id).toList();
  }

  Future<void> clear() async {
    _localState["todo"] = [];
    _localState["project"] = [];
    _localState["comment"] = [];
    _localState["reminder"] = [];
    notifyListeners();
  }
}

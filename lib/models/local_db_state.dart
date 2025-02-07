import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/logger.dart';
import 'core.dart';
import 'db_manager.dart';
import 'local_notifications_manager.dart';

class LocalDbState extends ChangeNotifier {
  DbSelector get dbManager => GetIt.I<DbSelector>();
  SharedDatabase get db => dbManager.database;
  RemoteDbSettings? get remoteDbSettings => dbManager.remoteDbSettings;

  final LocalNotificationsManager localNotificationsManager =
      LocalNotificationsManager();

  List<StreamSubscription<List<dynamic>>> _subscriptions = [];

  Timer? timer;

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
    initFromLocalTempDb();
    initFromDb();
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    timer?.cancel();
    super.dispose();
  }

  Future<void> syncReminders() async {
    if (reminders.isNotEmpty) {
      final status = await localNotificationsManager.register();
      if (status) {
        await localNotificationsManager.syncReminders(reminders);
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

  Future<StreamSubscription<List<int>>?> _initStreamForTable(
      String table, Future<void> Function(String) onChange,
      [int attemptsLeft = 5]) async {
    if (attemptsLeft == 0) {
      AppLogger.instance.w("Retried limit exceeded, cancelling");
      return null;
    }
    final uri = Uri.parse(remoteDbSettings!.url);
    final httpUri = Uri(
      scheme: "https",
      host: uri.host,
      path: "/beta/listen",
      queryParameters: {
        "table": table,
      },
    );
    AppLogger.instance.i("Starting to listen on stream for $table");
    http.Request request = http.Request("GET", httpUri);
    request.headers["Authorization"] = "Bearer ${remoteDbSettings!.token}";
    try {
      final response = await request.send();
      StreamSubscription<List<int>> subscription =
          response.stream.listen((event) {
        final stringifed = String.fromCharCodes(event).trim();
        if (stringifed == ":keep-alive") {
          return;
        }
        onChange(stringifed);
      });
      return subscription;
    } catch (e) {
      AppLogger.instance.e("Error listening to stream for $table, $e");
      return _initStreamForTable(table, onChange, attemptsLeft - 1);
    }
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
    setLocalTempDb(table, values);
  }

  Future<StreamSubscription<List<dynamic>>?>
      _refreshAndInitTable<T extends drift.DataClass>(
    drift.RootTableManager<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic,
            dynamic, dynamic, dynamic, T, dynamic>
        manager,
    String table,
  ) async {
    await onChange(manager, table);
    if (remoteDbSettings == null) {
      return manager.watch().listen((_) async {
        await onChange(manager, table);
      });
    } else {
      return await _initStreamForTable(table, (_) async {
        await onChange(manager, table);
      });
    }
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

  Future<void> _readFromLocalDb<T extends drift.DataClass>(
      String table, T Function(Map<String, dynamic>) fromJson) async {
    final entriesStr =
        await SharedPreferencesAsync().getString("LocalTempDb$table");
    if (entriesStr != null) {
      final entries = (jsonDecode(entriesStr) as List<dynamic>)
          .map<T>((a) => fromJson(a as Map<String, dynamic>))
          .toList();
      if (_localState[table] == null) {
        _localState[table] = entries;
        AppLogger.instance.d("Found local shared preferences for $table:");
        notifyListeners();
      }
    }
  }

  Future<void> _clearFromLocalDb(String table) async {
    await SharedPreferencesAsync().remove("LocalTempDb$table");
  }

  void initFromLocalTempDb() async {
    if (remoteDbSettings == null) return;
    await Future.wait([
      _readFromLocalDb<TodoData>("todo", TodoData.fromJson),
      _readFromLocalDb<ProjectData>("project", ProjectData.fromJson),
      _readFromLocalDb<CommentData>("comment", CommentData.fromJson),
      _readFromLocalDb<ReminderData>("reminder", ReminderData.fromJson),
    ]);
    await syncReminders();
  }

  Future<void> setLocalTempDb(String table, List<drift.DataClass> items) async {
    if (remoteDbSettings == null) return;
    await SharedPreferencesAsync().setString(
        "LocalTempDb$table", jsonEncode(items.map((a) => a.toJson()).toList()));
  }

  Future<void> clear() async {
    await Future.wait([
      _clearFromLocalDb("todo"),
      _clearFromLocalDb("project"),
      _clearFromLocalDb("comment"),
      _clearFromLocalDb("reminder"),
    ]);
    _localState["todo"] = [];
    _localState["project"] = [];
    _localState["comment"] = [];
    _localState["reminder"] = [];
    notifyListeners();
  }
}

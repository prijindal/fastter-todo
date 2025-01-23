import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/logger.dart';
import 'core.dart';
import 'db_manager.dart';
import 'local_notifications_manager.dart';

class LocalDbState extends ChangeNotifier {
  final SharedDatabase db;
  final LocalNotificationsManager localNotificationsManager =
      LocalNotificationsManager();
  final RemoteDbSettings? remoteDbSettings;

  List<StreamSubscription<List<int>>> _subscriptions = [];

  Timer? timer;

  List<TodoData> _todos = [];
  List<ProjectData> _projects = [];
  List<CommentData> _comments = [];
  List<ReminderData> _reminders = [];

  final Map<String, List<drift.DataClass>> _localState = {};

  List<TodoData> get todos => List.unmodifiable(_isTodosInitialized
      ? _todos
      : (_localState["todos"] as List<TodoData>?) ?? []);
  List<ProjectData> get projects => List.unmodifiable(_isProjectsInitialized
      ? _projects
      : (_localState["projects"] as List<ProjectData>?) ?? []);
  List<CommentData> get comments => List.unmodifiable(_isCommentsInitialized
      ? _comments
      : (_localState["comments"] as List<CommentData>?) ?? []);
  List<ReminderData> get reminders => List.unmodifiable(_isRemindersInitialized
      ? _reminders
      : (_localState["reminders"] as List<ReminderData>?) ?? []);

  bool _isTodosInitialized = false;
  bool _isProjectsInitialized = false;
  bool _isCommentsInitialized = false;
  bool _isRemindersInitialized = false;

  bool _isRefreshing = false;

  bool get isRefreshing => _isRefreshing;

  bool get isTodosInitialized =>
      _localState["todos"] != null || _isTodosInitialized;

  bool get isInitialized =>
      (_localState["todos"] != null || _isTodosInitialized) &&
      (_localState["projects"] != null || _isProjectsInitialized) &&
      (_localState["comments"] != null || _isCommentsInitialized) &&
      (_localState["reminders"] != null || _isRemindersInitialized);

  LocalDbState(this.db, {this.remoteDbSettings}) {
    // Local state is first initialized with local storage, this makes sure that when we first do init, we have some data on ui
    // This is only really useful when our sqlite db is a remote one
    initFromLocalTempDb();
    initStream();
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
    await initStream();
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
    if (remoteDbSettings != null) {
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
    } else {
      return null;
    }
  }

  Future<StreamSubscription<List<int>>?> _refreshAndInitTable(
      String table, Future<void> Function(String) onChange) async {
    await onChange("init");
    return await _initStreamForTable(table, onChange);
  }

  Future<void> initStream() async {
    final subscriptions = await Future.wait([
      _refreshAndInitTable("todo", (_) async {
        final values = await db.managers.todo.get();
        _todos = values.toList();
        _isTodosInitialized = true;
        notifyListeners();
        setLocalTempDb("todos", values);
      }),
      _refreshAndInitTable("project", (_) async {
        final values = await db.managers.project.get();
        _projects = values.toList();
        _isProjectsInitialized = true;
        notifyListeners();
        setLocalTempDb("projects", values);
      }),
      _refreshAndInitTable("reminder", (_) async {
        final values = await db.managers.reminder.get();
        _reminders = values.toList();
        _isRemindersInitialized = true;
        notifyListeners();
        setLocalTempDb("reminders", values);
      }),
      _refreshAndInitTable("comment", (_) async {
        final values = await db.managers.comment.get();
        _comments = values.toList();
        _isCommentsInitialized = true;
        notifyListeners();
        setLocalTempDb("comments", values);
      }),
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
    final todo = todos.firstWhere((element) => element.id == id);
    return todo.tags;
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
    await Future.wait([
      _readFromLocalDb<TodoData>("todos", TodoData.fromJson),
      _readFromLocalDb<ProjectData>("projects", ProjectData.fromJson),
      _readFromLocalDb<CommentData>("comments", CommentData.fromJson),
      _readFromLocalDb<ReminderData>("reminders", ReminderData.fromJson),
    ]);
    await syncReminders();
  }

  Future<void> setLocalTempDb(String table, List<drift.DataClass> items) async {
    await SharedPreferencesAsync().setString(
        "LocalTempDb$table", jsonEncode(items.map((a) => a.toJson()).toList()));
  }

  Future<void> clear() async {
    await Future.wait([
      _clearFromLocalDb("todos"),
      _clearFromLocalDb("projects"),
      _clearFromLocalDb("comments"),
      _clearFromLocalDb("reminders"),
    ]);
    _todos = [];
    _projects = [];
    _comments = [];
    _reminders = [];
    notifyListeners();
  }
}

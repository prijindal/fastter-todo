import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/logger.dart';
import 'core.dart';
import 'local_notifications_manager.dart';

class LocalDbState extends ChangeNotifier {
  final SharedDatabase db;
  final LocalNotificationsManager _localNotificationsManager =
      LocalNotificationsManager();

  StreamSubscription<List<TodoData>>? _todosSubscription;
  StreamSubscription<List<ProjectData>>? _projectsSubscription;
  StreamSubscription<List<CommentData>>? _commentsSubscription;
  StreamSubscription<List<ReminderData>>? _remindersSubscription;

  Timer? timer;

  List<TodoData> _todos = [];
  List<ProjectData> _projects = [];
  List<CommentData> _comments = [];
  List<ReminderData> _reminders = [];

  final Map<String, List<drift.DataClass>> _localState = {};

  List<TodoData> get todos => _isTodosInitialized
      ? _todos
      : (_localState["todos"] as List<TodoData>?) ?? [];
  List<ProjectData> get projects => _isProjectsInitialized
      ? _projects
      : (_localState["projects"] as List<ProjectData>?) ?? [];
  List<CommentData> get comments => _isCommentsInitialized
      ? _comments
      : (_localState["comments"] as List<CommentData>?) ?? [];
  List<ReminderData> get reminders => _isRemindersInitialized
      ? _reminders
      : (_localState["reminders"] as List<ReminderData>?) ?? [];

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

  LocalDbState(this.db) {
    // Local state is first initialized with local storage, this makes sure that when we first do init, we have some data on ui
    // This is only really useful when our sqlite db is a remote one
    initFromLocalTempDb();
    initSubscriptions();
    const duration = Duration(seconds: 10); // TODO: Make this configurable
    timer = Timer.periodic(duration, (_) => refresh());
  }

  @override
  void dispose() {
    cancelSubscriptions();
    timer?.cancel();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await Future.wait([
      db.managers.todo.get().then((values) => _todos = values),
      db.managers.project.get().then((values) => _projects = values),
      db.managers.comment.get().then((values) => _comments = values),
      db.managers.reminder.get().then((values) => _reminders = values),
    ]);
  }

  Future<void> syncReminders() async {
    if (reminders.isNotEmpty) {
      final status = await _localNotificationsManager.register();
      if (status) {
        await _localNotificationsManager.syncReminders(reminders);
      }
    }
  }

  Future<void> refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    notifyListeners();
    await _refreshData();
    await syncReminders();
    _isRefreshing = false;
    notifyListeners();
  }

  void initSubscriptions() {
    cancelSubscriptions();
    _todosSubscription = db.managers.todo.watch().listen((event) {
      _todos = event;
      _isTodosInitialized = true;
      notifyListeners();
      setLocalTempDb("todos", event);
    });
    _projectsSubscription = db.managers.project.watch().listen((event) {
      _projects = event;
      _isProjectsInitialized = true;
      notifyListeners();
      setLocalTempDb("projects", event);
    });
    _commentsSubscription = db.managers.comment.watch().listen((event) {
      _comments = event;
      _isCommentsInitialized = true;
      notifyListeners();
      setLocalTempDb("comments", event);
    });
    _remindersSubscription = db.managers.reminder.watch().listen((event) {
      _reminders = event;
      _isRemindersInitialized = true;
      notifyListeners();
      setLocalTempDb("reminders", event);
    });
  }

  void cancelSubscriptions() {
    _todosSubscription?.cancel();
    _projectsSubscription?.cancel();
    _commentsSubscription?.cancel();
    _remindersSubscription?.cancel();
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

  void initFromLocalTempDb() async {
    await Future.wait([
      _readFromLocalDb<TodoData>("todos", TodoData.fromJson),
      _readFromLocalDb<ProjectData>("projects", ProjectData.fromJson),
      _readFromLocalDb<CommentData>("comments", CommentData.fromJson),
      _readFromLocalDb<ReminderData>("reminders", ReminderData.fromJson),
    ]);
  }

  Future<void> setLocalTempDb(String table, List<drift.DataClass> items) async {
    await SharedPreferencesAsync().setString(
        "LocalTempDb$table", jsonEncode(items.map((a) => a.toJson()).toList()));
  }
}

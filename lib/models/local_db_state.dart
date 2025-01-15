import 'dart:async';

import 'package:flutter/widgets.dart';

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

  List<TodoData> todos = [];
  List<ProjectData> projects = [];
  List<CommentData> comments = [];
  List<ReminderData> reminders = [];

  bool _isTodosInitialized = false;
  bool _isProjectsInitialized = false;
  bool _isCommentsInitialized = false;
  bool _isRemindersInitialized = false;

  bool _isRefreshing = false;

  bool get isRefreshing => _isRefreshing;

  bool get isInitialized =>
      _isTodosInitialized &&
      _isProjectsInitialized &&
      _isCommentsInitialized &&
      _isRemindersInitialized;

  LocalDbState(this.db) {
    initSubscriptions();
    const duration = Duration(seconds: 2);
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
      db.managers.todo.get().then((values) => todos = values),
      db.managers.project.get().then((values) => projects = values),
      db.managers.comment.get().then((values) => comments = values),
      db.managers.reminder.get().then((values) => reminders = values),
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
    final counts = await Future.wait([
      db.managers.todo.count(),
      db.managers.project.count(),
      db.managers.comment.count(),
      db.managers.reminder.count(),
    ]);
    // Only refresh if counts are mismatched
    if (counts[0] != todos.length ||
        counts[1] != projects.length ||
        counts[2] != comments.length ||
        counts[3] != reminders.length) {
      await _refreshData();
    }
    await syncReminders();
    _isRefreshing = false;
    notifyListeners();
  }

  void initSubscriptions() {
    cancelSubscriptions();
    _todosSubscription = db.managers.todo.watch().listen((event) {
      todos = event;
      _isTodosInitialized = true;
      notifyListeners();
    });
    _projectsSubscription = db.managers.project.watch().listen((event) {
      projects = event;
      _isProjectsInitialized = true;
      notifyListeners();
    });
    _commentsSubscription = db.managers.comment.watch().listen((event) {
      comments = event;
      _isCommentsInitialized = true;
      notifyListeners();
    });
    _remindersSubscription = db.managers.reminder.watch().listen((event) {
      reminders = event;
      _isRemindersInitialized = true;
      notifyListeners();
    });
  }

  void cancelSubscriptions() {
    _todosSubscription?.cancel();
    _projectsSubscription?.cancel();
    _commentsSubscription?.cancel();
    _remindersSubscription?.cancel();
  }
}

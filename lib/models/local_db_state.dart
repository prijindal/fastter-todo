import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:flutter/widgets.dart';

import 'core.dart';

class LocalDbState extends ChangeNotifier {
  final SharedDatabase db;

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
    const duration = Duration(seconds: 10);
    timer = Timer.periodic(duration, (_) => refresh());
  }

  @override
  void dispose() {
    cancelSubscriptions();
    timer?.cancel();
    super.dispose();
  }

  Future<void> refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    notifyListeners();
    final entries = await db.computeWithDatabase<List<List<DataClass>>>(
      computation: (database) async {
        final [todo, project, comment, reminder] = await Future.wait([
          database.managers.todo.get(),
          database.managers.project.get(),
          database.managers.comment.get(),
          database.managers.reminder.get(),
        ]);
        return [todo, project, comment, reminder];
      },
      connect: (connection) => SharedDatabase(connection),
    );
    todos = entries[0] as List<TodoData>;
    projects = entries[1] as List<ProjectData>;
    comments = entries[2] as List<CommentData>;
    reminders = entries[3] as List<ReminderData>;
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

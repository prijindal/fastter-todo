import 'dart:async';

import 'package:flutter/widgets.dart';

import 'core.dart';

class LocalDbState extends ChangeNotifier {
  final SharedDatabase db;

  StreamSubscription<List<TodoData>>? _todosSubscription;
  StreamSubscription<List<ProjectData>>? _projectsSubscription;
  StreamSubscription<List<CommentData>>? _commentsSubscription;
  StreamSubscription<List<ReminderData>>? _remindersSubscription;

  List<TodoData> todos = [];
  List<ProjectData> projects = [];
  List<CommentData> comments = [];
  List<ReminderData> reminders = [];

  bool _isTodosInitialized = false;
  bool _isProjectsInitialized = false;
  bool _isCommentsInitialized = false;
  bool _isRemindersInitialized = false;

  bool get isInitialized =>
      _isTodosInitialized &&
      _isProjectsInitialized &&
      _isCommentsInitialized &&
      _isRemindersInitialized;

  LocalDbState(this.db) {
    initSubscriptions();
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

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }
}

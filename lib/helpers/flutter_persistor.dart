import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../store/labels.dart';
import '../store/projects.dart';
import '../store/todocomments.dart';
import '../store/todoreminders.dart';
import '../store/todos.dart';
import '../store/user.dart';
import 'package:fastter_todo/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fastter/fastter_bloc.dart';
import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../models/todocomment.model.dart';
import '../models/todoreminder.model.dart';
import '../models/label.model.dart';
import '../models/project.model.dart';
import '../models/user.model.dart';

class FlutterPersistor {
  SharedPreferences? _sharedPreferences;

  static FlutterPersistor? _instance;

  static FlutterPersistor getInstance() {
    if (_instance == null) {
      _instance = FlutterPersistor();
    }
    return _instance!;
  }

  Future<void> _initSharedPreferences() async {
    if (Platform.isAndroid || Platform.isIOS) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Map<String, dynamic> _loadKey(String key) {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final string = _sharedPreferences?.getString(key);
        if (string == null) {
          return <String, dynamic>{};
        }
        return json.decode(string);
      } else {
        final homeFolder = Platform.environment['HOME'];
        final file = File('$homeFolder/.config/fastter_todo/$key.json');
        if (file.existsSync()) {
          return json.decode(file.readAsStringSync());
        } else {
          return <String, dynamic>{};
        }
      }
    } on Exception {
      return <String, dynamic>{};
    }
  }

  Future<void> _saveKey(String key, Map<String, dynamic> value) async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await _sharedPreferences?.setString(key, json.encode(value));
      } on Exception catch (e) {
        print(e);
      }
    } else {
      final homeFolder = Platform.environment['HOME'];
      final file = File('$homeFolder/.config/fastter_todo/$key.json');
      file.createSync(recursive: true);
      await file.writeAsString(json.encode(value));
    }
  }

  String? loadString(String key) {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final string = _sharedPreferences?.getString(key);
        return string;
      } else {
        final homeFolder = Platform.environment['HOME'];
        final file = File('$homeFolder/.config/fastter_todo/$key.txt');
        if (file.existsSync()) {
          return file.readAsStringSync();
        } else {
          return null;
        }
      }
    } on Exception {
      return null;
    }
  }

  Future<void> setString(String key, String value) async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await _sharedPreferences?.setString(key, value);
      } on Exception catch (e) {
        print(e);
      }
    } else {
      final homeFolder = Platform.environment['HOME'];
      final file = File('$homeFolder/.config/fastter_todo/$key.txt');
      file.createSync(recursive: true);
      await file.writeAsString(value);
    }
  }

  Future<void> clearString(String key) async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await _sharedPreferences?.remove(key);
      } on Exception catch (e) {
        print(e);
      }
    } else {
      final homeFolder = Platform.environment['HOME'];
      final file = File('$homeFolder/.config/fastter_todo/$key.txt');
      if (file.existsSync()) {
        file.deleteSync(recursive: true);
      }
    }
  }

  void initListeners() {
    fastterUser.stream.listen((data) {
      _saveKey('user', data.toJson());
    });
    fastterTodos.stream.listen((data) {
      _saveKey('todos', data.toJson());
    });
    fastterProjects.stream.listen((data) {
      _saveKey('projects', data.toJson());
    });
    fastterLabels.stream.listen((data) {
      _saveKey('labels', data.toJson());
    });
    fastterTodoComments.stream.listen((data) {
      _saveKey('todoComments', data.toJson());
    });
    fastterTodoReminders.stream.listen((data) {
      _saveKey('todoReminders', data.toJson());
    });
  }

  void _loadState<T extends BaseModel>(
    FastterBloc<T> bloc,
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final todos = ListState<T>.fromJson(
      _loadKey(key),
      (dynamic t) => fromJson(t),
    );
    bloc.add(InitStateEvent<T>(todos));
  }

  Future<void> load() async {
    await _initSharedPreferences();
    final user = UserState.fromJson(
      _loadKey('user'),
    );
    fastterUser.add(InitStateUserEvent(user));
    _loadState<Todo>(fastterTodos, 'todos', (a) => Todo.fromJson(a));
    _loadState<Project>(
        fastterProjects, 'projects', (a) => Project.fromJson(a));
    _loadState<Label>(fastterLabels, 'labels', (a) => Label.fromJson(a));
    _loadState<TodoComment>(
        fastterTodoComments, 'todoComments', (a) => TodoComment.fromJson(a));
    _loadState<TodoReminder>(
        fastterTodoReminders, 'todoReminders', (a) => TodoReminder.fromJson(a));
  }
}

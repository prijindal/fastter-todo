import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fastter_dart/store/labels.dart';
import 'package:fastter_dart/store/projects.dart';
import 'package:fastter_dart/store/todocomments.dart';
import 'package:fastter_dart/store/todoreminders.dart';
import 'package:fastter_dart/store/todos.dart';
import 'package:fastter_dart/store/user.dart';
import 'package:fastter_todo/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import 'package:fastter_dart/models/todoreminder.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/user.model.dart';

class FlutterPersistor {
  SharedPreferences _sharedPreferences;

  Future<void> _initSharedPreferences() async {
    if (Platform.isAndroid || Platform.isIOS) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Map<String, dynamic> _loadKey(String key) {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final string = _sharedPreferences.getString(key);
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
        await _sharedPreferences.setString(key, json.encode(value));
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

  void initListeners() {
    fastterUser.state.listen((data) {
      if (data != null && data.bearer != null) {
        _saveKey('user', data.toJson());
      }
    });
    fastterTodos.state.listen((data) {
      if (data != null && data.items != null && data.items.isNotEmpty) {
        _saveKey('todos', data.toJson());
      }
    });
    fastterProjects.state.listen((data) {
      if (data != null && data.items != null && data.items.isNotEmpty) {
        _saveKey('projects', data.toJson());
      }
    });
    fastterLabels.state.listen((data) {
      if (data != null && data.items != null && data.items.isNotEmpty) {
        _saveKey('labels', data.toJson());
      }
    });
    fastterTodoComments.state.listen((data) {
      if (data != null && data.items != null && data.items.isNotEmpty) {
        _saveKey('todoComments', data.toJson());
      }
    });
    fastterTodoReminders.state.listen((data) {
      if (data != null && data.items != null && data.items.isNotEmpty) {
        _saveKey('todoReminders', data.toJson());
      }
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
    bloc.dispatch(InitStateEvent<T>(todos));
  }

  Future<void> load() async {
    await _initSharedPreferences();
    final user = UserState.fromJson(
      _loadKey('user'),
    );
    fastterUser.dispatch(InitStateUserEvent(user));
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

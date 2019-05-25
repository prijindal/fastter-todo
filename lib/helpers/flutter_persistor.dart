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

  void _saveKey(String key, Map<String, dynamic> value) {
    if (Platform.isAndroid || Platform.isIOS) {
      _sharedPreferences.setString(key, json.encode(value));
    } else {
      final homeFolder = Platform.environment['HOME'];
      final file = File('$homeFolder/.config/fastter_todo/$key.json');
      file.createSync(recursive: true);
      file.writeAsString(json.encode(value));
    }
  }

  void initListeners() {
    fastterUser.state.listen((data) {
      _saveKey('user', data.toJson());
    });
    fastterTodos.state.listen((data) {
      _saveKey('todos', data.toJson());
    });
    fastterProjects.state.listen((data) {
      _saveKey('projects', data.toJson());
    });
    fastterLabels.state.listen((data) {
      _saveKey('labels', data.toJson());
    });
    fastterTodoComments.state.listen((data) {
      _saveKey('todoComments', data.toJson());
    });
    fastterTodoReminders.state.listen((data) {
      _saveKey('todoReminders', data.toJson());
    });
  }

  Future<void> load() async {
    await _initSharedPreferences();
    final user = UserState.fromJson(
      _loadKey('user'),
    );
    fastterUser.dispatch(InitStateUserEvent(user));
    final todos = ListState<Todo>.fromJson(
      _loadKey('todos'),
      (dynamic t) => Todo.fromJson(t),
    );
    fastterTodos.dispatch(InitStateEvent<Todo>(todos));
    final projects = ListState<Project>.fromJson(
      _loadKey('projects'),
      (dynamic t) => Project.fromJson(t),
    );
    fastterProjects.dispatch(InitStateEvent<Project>(projects));
    final labels = ListState<Label>.fromJson(
      _loadKey('labels'),
      (dynamic t) => Label.fromJson(t),
    );
    fastterLabels.dispatch(InitStateEvent<Label>(labels));
    final todoComments = ListState<TodoComment>.fromJson(
      _loadKey('todoComments'),
      (dynamic t) => TodoComment.fromJson(t),
    );
    fastterTodoComments.dispatch(InitStateEvent<TodoComment>(todoComments));
    final todoReminders = ListState<TodoReminder>.fromJson(
      _loadKey('todoReminders'),
      (dynamic t) => TodoReminder.fromJson(t),
    );
    fastterTodoReminders.dispatch(InitStateEvent<TodoReminder>(todoReminders));
  }
}

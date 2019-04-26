import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux_persist/redux_persist.dart' show Persistor;

import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import 'package:fastter_dart/models/todoreminder.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/user.model.dart';
import 'package:fastter_dart/models/lazyaction.model.dart';
import 'package:fastter_dart/store/state.dart';

class FlutterPersistor extends Persistor<AppState> {
  SharedPreferences _sharedPreferences;

  Future<void> _initSharedPreferences() async {
    if (Platform.isAndroid || Platform.isIOS) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  String _loadKey(String key) {
    if (Platform.isAndroid || Platform.isIOS) {
      final string = _sharedPreferences.getString(key);
      if (string == null) {
        return '';
      }
      return string;
    } else {
      final homeFolder = Platform.environment['HOME'];
      final file = File('$homeFolder/.config/fastter_todo/$key.json');
      if (file.existsSync()) {
        return file.readAsStringSync();
      } else {
        return '';
      }
    }
  }

  void _saveKey(String key, String value) {
    if (Platform.isAndroid || Platform.isIOS) {
      _sharedPreferences.setString(key, value);
    } else {
      final homeFolder = Platform.environment['HOME'];
      final file = File('$homeFolder/.config/fastter_todo/$key.json');
      file.createSync(recursive: true);
      file.writeAsString(value);
    }
  }

  List<LazyAction> get _decodeLazyActions {
    final List<dynamic> list = json.decode(_loadKey('lazyActions'));
    return list.map((dynamic t) => LazyAction.fromJson(t)).toList();
  }

  @override
  Future<AppState> load() async {
    await _initSharedPreferences();
    return AppState(
      user: UserState.fromJson(
        json.decode(_loadKey('user')),
      ),
      todos: ListState<Todo>.fromJson(
        json.decode(_loadKey('todos')),
        (dynamic t) => Todo.fromJson(t),
      ),
      projects: ListState<Project>.fromJson(
        json.decode(_loadKey('projects')),
        (dynamic t) => Project.fromJson(t),
      ),
      labels: ListState<Label>.fromJson(
        json.decode(_loadKey('labels')),
        (dynamic t) => Label.fromJson(t),
      ),
      todoComments: ListState<TodoComment>.fromJson(
        json.decode(_loadKey('todoComments')),
        (dynamic t) => TodoComment.fromJson(t),
      ),
      todoReminders: ListState<TodoReminder>.fromJson(
        json.decode(_loadKey('todoReminders')),
        (dynamic t) => TodoReminder.fromJson(t),
      ),
      lazyActions: _decodeLazyActions,
    );
  }

  @override
  Future<void> save(AppState state) async {
    await _initSharedPreferences();
    _saveKey('user', json.encode(state.user.toJson()));
    _saveKey('todos', json.encode(state.todos.toJson()));
    _saveKey('projects', json.encode(state.projects.toJson()));
    _saveKey('labels', json.encode(state.labels.toJson()));
    _saveKey('todoComments', json.encode(state.todoComments.toJson()));
    _saveKey('todoReminders', json.encode(state.todoReminders.toJson()));
    _saveKey('lazyActions',
        json.encode(state.lazyActions.map((t) => t.toJson()).toList()));
  }
}

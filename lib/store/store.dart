import 'dart:io';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_logging/redux_logging.dart';

import '../models/user.model.dart';
import 'currentuser.dart';
import 'bearer.dart';
import 'todos.dart';
import 'projects.dart';
import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../models/project.model.dart';

class AppState {
  AppState({
    this.user,
    this.bearer,
    this.rehydrated = false,
    this.todos,
    this.projects,
  });

  bool rehydrated;
  User user;
  String bearer;
  ListState<Todo> todos;
  ListState<Project> projects;

  static AppState fromJson(dynamic json) {
    if (json != null && json['user'] != null) {
      return AppState(
        user: User.fromJson(json['user']),
        bearer: json['bearer'],
        todos: ListState<Todo>(
          fetching: false,
          datas: json['todos'] != null && json['todos']['datas'] != null
              ? (json['todos']['datas'] as List<dynamic>)
                  .map<Todo>((t) => Todo.fromJson(t))
                  .toList()
              : [],
        ),
        projects: ListState<Project>(
          fetching: false,
          datas: json['projects'] != null && json['projects']['datas'] != null
              ? (json['projects']['datas'] as List<dynamic>)
                  .map<Project>((t) => Project.fromJson(t))
                  .toList()
              : [],
        ),
      );
    } else {
      return AppState();
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user != null ? user.toJson() : <String, dynamic>{},
        'bearer': bearer,
        'todos': todos.toJson(),
        'projects': projects.toJson(),
      };

  @override
  String toString() {
    final Map<String, dynamic> json = toJson();
    json.addAll(<String, dynamic>{
      'rehydrated': rehydrated,
    });
    return json.toString();
  }
}

class InitStateReset {
  InitStateReset(this.user, this.bearer);
  final User user;
  final String bearer;
}

AppState appStateReducer(AppState state, dynamic action) {
  if (action is InitStateReset) {
    return AppState(
      user: action.user,
      bearer: action.bearer,
      rehydrated: true,
      todos: ListState<Todo>(),
      projects: ListState<Project>(),
    );
  }
  return AppState(
    rehydrated: state.rehydrated,
    user: userReducer(state.user, action),
    bearer: bearerReducer(state.bearer, action),
    todos: todosReducer(state.todos, action),
    projects: projectsReducer(state.projects, action),
  );
}

Future<Store<AppState>> initState() async {
  dynamic storage;
  if (Platform.isAndroid || Platform.isIOS) {
    storage = FlutterStorage();
  } else {
    storage = FileStorage(File('state.json'));
  }
  final Persistor<AppState> _persistor = Persistor<AppState>(
    storage: storage, // Or use other engines
    serializer:
        JsonSerializer<AppState>(AppState.fromJson), // Or use other serializers
  );
  final Store<AppState> _store = Store<AppState>(
    appStateReducer,
    initialState: AppState(
      rehydrated: false,
    ),
    middleware: <Middleware<AppState>>[
      // LoggingMiddleware<AppState>.printer(),
      _persistor.createMiddleware(),
    ],
  );

  _persistor.load().then((AppState state) {
    _store.dispatch(InitStateReset(state.user, state.bearer));
  });

  return _store;
}

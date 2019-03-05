import 'dart:io';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_logging/redux_logging.dart';

import '../models/user.model.dart';
import 'currentuser.dart';
import 'bearer.dart';
import 'todos.dart';
import '../models/base.model.dart';
import '../models/todo.model.dart';

class AppState {
  AppState({
    this.user,
    this.bearer,
    this.rehydrated = false,
    this.todos,
  });

  bool rehydrated;
  User user;
  String bearer;
  ListState<Todo> todos;

  static AppState fromJson(dynamic json) {
    if (json != null && json['user'] != null) {
      return AppState(
        user: User.fromJson(json['user']),
        bearer: json['bearer'],
      );
    } else {
      return AppState();
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user != null ? user.toJson() : <String, dynamic>{},
        'bearer': bearer,
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
    );
  }
  return AppState(
    rehydrated: state.rehydrated,
    user: userReducer(state.user, action),
    bearer: bearerReducer(state.bearer, action),
    todos: todosReducer(state.todos, action),
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

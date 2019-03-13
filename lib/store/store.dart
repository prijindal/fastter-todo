import 'dart:io';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

import 'projects.dart';
import 'reducer.dart';
import 'state.dart';
import 'todos.dart';
import 'user.dart';
import 'todocomments.dart';

Future<Store<AppState>> initState() async {
  dynamic storage;
  if (Platform.isAndroid || Platform.isIOS) {
    storage = FlutterStorage();
  } else {
    final homeFolder = Platform.environment['HOME'];
    final file = File('$homeFolder/.config/fastter_flutter/state.json');
    file.createSync(recursive: true);
    storage = FileStorage(file);
  }
  final _persistor = Persistor<AppState>(
    storage: storage, // Or use other engines
    serializer: JsonSerializer<AppState>(
        (dynamic data) => AppState.fromJson(data)), // Or use other serializers
  );
  final _store = Store<AppState>(
    appStateReducer,
    initialState: AppState(
      rehydrated: false,
    ),
    middleware: <Middleware<AppState>>[
      _persistor.createMiddleware(),
      fastterProjects.middleware,
      fastterTodos.middleware,
      fastterTodoComments.middleware,
      UserMiddleware(),
    ],
  );

  try {
    final state = await _persistor.load();
    if (state.user != null &&
        state.user.user != null &&
        state.user.bearer != null) {
      _store.dispatch(
        InitStateReset(
          user: state.user,
          projects: state.projects,
          todos: state.todos,
          todoComments: state.todoComments,
        ),
      );
    } else {
      _store.dispatch(ClearAll());
    }
  } catch (error) {
    _store.dispatch(ClearAll());
  }

  return _store;
}

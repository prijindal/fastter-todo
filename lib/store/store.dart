import 'dart:io';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

import 'todos.dart';
import 'projects.dart';
import 'user.dart';
import './state.dart';
import './reducer.dart';

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
      _persistor.createMiddleware(),
      fastterProjects.middleware,
      fastterTodos.middleware,
      UserMiddleware(),
    ],
  );

  _persistor.load().then((AppState state) {
    if (state.user != null &&
        state.user.user != null &&
        state.user.bearer != null) {
      fastterProjects.queries.initSubscriptions(_store);
      fastterTodos.queries.initSubscriptions(_store);

      _store.dispatch(
        InitStateReset(
          user: state.user,
          projects: state.projects,
          todos: state.todos,
        ),
      );
    } else {
      _store.dispatch(ClearAll());
    }
  });

  return _store;
}

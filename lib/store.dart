import 'dart:io';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:fastter_dart/fastter/lazyactions.dart';
import 'package:fastter_dart/store/projects.dart';
import 'package:fastter_dart/store/labels.dart';
import 'package:fastter_dart/store/reducer.dart';
import 'package:fastter_dart/store/state.dart';
import 'package:fastter_dart/store/todos.dart';
import 'package:fastter_dart/store/user.dart';
import 'package:fastter_dart/store/todocomments.dart';
import 'package:fastter_dart/store/todoreminders.dart';
import 'package:fastter_dart/store/lazyactions.dart';

import 'helpers/firebase.dart' show initMessaging;

Future<Store<AppState>> initState() async {
  StorageEngine storage;
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
      fastterLabels.middleware,
      fastterTodos.middleware,
      fastterTodoComments.middleware,
      fastterTodoReminders.middleware,
      LazyActionsMiddleware(),
      UserMiddleware(
        initMessaging: initMessaging,
        onLogout: () {
          final _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
          _googleSignIn.signOut();
        },
      ),
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
          lazyActions: state.lazyActions,
        ),
      );
      _store.dispatch(InitLazyActions());
    } else {
      _store.dispatch(ClearAll());
    }
  } catch (error) {
    _store.dispatch(ClearAll());
  }

  return _store;
}

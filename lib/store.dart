import 'package:redux/redux.dart';
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
import 'package:fastter_dart/store/notifications.dart';
import 'package:fastter_dart/store/lazyactions.dart';

import 'helpers/firebase.dart' show initMessaging;
import 'helpers/flutter_persistor.dart' show FlutterPersistor;

Future<Store<AppState>> initState() async {
  final _persistor = FlutterPersistor();
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
      fastterNotifications.middleware,
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

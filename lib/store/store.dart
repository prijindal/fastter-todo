import 'dart:io';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_logging/redux_logging.dart';

class AppState {
  AppState({
    this.rehydrated = false,
  });

  bool rehydrated;

  static AppState fromJson(dynamic json) {
    if (json != null && json['login'] != null) {
      return AppState();
    } else {
      return AppState();
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{};

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
  InitStateReset();
}

AppState appStateReducer(AppState state, dynamic action) {
  if (action is InitStateReset) {
    return AppState(
      rehydrated: true,
    );
  }
  return AppState(
    rehydrated: state.rehydrated,
  );
}

Store<AppState> store;
Persistor<AppState> persistor;

Future<void> initState() async {
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
      LoggingMiddleware<AppState>.printer(),
      _persistor.createMiddleware(),
    ],
  );

  _persistor.load().then((AppState state) {
    _store.dispatch(InitStateReset());
  });

  store = _store;
  persistor = _persistor;
}

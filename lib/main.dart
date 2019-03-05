import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'helpers/theme.dart';
import 'routes/root.dart';
import 'screens/loading.dart';
import 'store/store.dart';

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

Future<void> main() async {
  _setTargetPlatformForDesktop();
  bool isInDebugMode = false;
  profile(() {
    isInDebugMode = true;
  });

  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  final store = await initState();

  runZoned<Future<void>>(() async {
    runApp(FlutterReduxApp(store));
  }, onError: (Object error, StackTrace stackTrace) async {
    debugPrint(error.toString());
  });
}

class FlutterReduxApp extends StatelessWidget {
  const FlutterReduxApp(this.store, {Key key}) : super(key: key);

  @required
  final Store<AppState> store;
  // @required
  // final Persistor<AppState> persistor;

  @override
  Widget build(BuildContext context) {
    if (store == null) {
      return MaterialApp(
        theme: primaryTheme,
        home: LoadingScreen(),
      );
    }
    return StoreProvider<AppState>(
      store: store,
      child: RootContainer(),
    );
  }
}

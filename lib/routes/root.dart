import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../screens//loading.dart';
import '../store/state.dart';
import '../helpers/theme.dart';
import './app.dart';

class RootContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (BuildContext context, AppState state) {
        return ((state == null || state.rehydrated == false)
            ? MaterialApp(
                theme: primaryTheme,
                home: LoadingScreen(),
              )
            : AppContainer());
      },
    );
  }
}

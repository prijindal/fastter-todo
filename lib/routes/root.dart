import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../helpers/theme.dart';
import '../screens//loading.dart';
import 'package:fastter_dart/store/state.dart';
import './app.dart';

class RootContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) => state == null || state.rehydrated == false
            ? MaterialApp(
                theme: primaryTheme,
                home: LoadingScreen(),
              )
            : AppContainer(),
      );
}

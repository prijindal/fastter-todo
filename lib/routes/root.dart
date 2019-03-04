import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../screens//loading.dart';
import '../store/store.dart';

ThemeData primaryTheme = ThemeData(primarySwatch: Colors.orange);

class RootContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (BuildContext context, AppState state) {
        return MaterialApp(
          title: 'News App',
          theme: primaryTheme,
          home: (state == null || state.rehydrated == false)
              ? LoadingScreen()
              : Scaffold(
                  body: AnimatedCrossFade(
                    crossFadeState: (state == null)
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: LoadingScreen(),
                    secondChild: LoadingScreen(),
                    duration: const Duration(milliseconds: 500),
                  ),
                ),
        );
      },
    );
  }
}

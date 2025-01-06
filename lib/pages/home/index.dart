import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/backup/firebase/firebase_sync.dart';
import 'home_app_bar.dart';
import 'todo_list_scaffold.dart';
// import 'calendar.dart';

const mediaBreakpoint = 700;

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeScreen> {
  @override
  void initState() {
    // Timer(
    //   const Duration(seconds: 1),
    //   () => _initSync(),
    // );
    // Timer(
    //   const Duration(seconds: 3),
    //   () => _sync(),
    // );
    super.initState();
  }

  Future<void> _initSync() async {
    // This is just to initialize firebase and gdrive sync after firebase init is called
    Provider.of<FirebaseSync>(context, listen: false);
  }

  Future<void> _sync() async {
    await Future.wait([
      Provider.of<FirebaseSync>(context, listen: false)
          .sync(context, suppressErrors: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return TodoListScaffold(
      appBar: const HomeAppBar(),
    );
  }
}

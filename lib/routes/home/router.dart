import 'package:flutter/material.dart';

import 'package:fastter_dart/fastter/fastter.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/settings.model.dart';

import '../../helpers/firebase.dart';
import '../../helpers/navigator.dart';
import '../../helpers/theme.dart';

import 'generateroute.dart' show onGenerateRoute;

class HomePage extends StatefulWidget {
  const HomePage({
    @required this.labelSyncStart,
    @required this.projectSyncStart,
    @required this.todoSyncStart,
    @required this.todoCommentsSyncStart,
    @required this.todoRemindersSyncStart,
    @required this.notificationsSyncStart,
    @required this.initSubscriptions,
    @required this.confirmUser,
    @required this.frontPage,
  });

  final Future<List<Project>> Function() projectSyncStart;
  final Future<List<Label>> Function() labelSyncStart;
  final Future<List<Todo>> Function() todoSyncStart;
  final VoidCallback todoCommentsSyncStart;
  final VoidCallback todoRemindersSyncStart;
  final VoidCallback notificationsSyncStart;
  final VoidCallback initSubscriptions;
  final void Function(String) confirmUser;
  final FrontPage frontPage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initRequests();
  }

  Future<void> _initRequests() async {
    await widget.todoSyncStart();
    await widget.projectSyncStart();
    await widget.labelSyncStart();
    widget.todoCommentsSyncStart();
    widget.todoRemindersSyncStart();
    widget.notificationsSyncStart();
    widget.initSubscriptions();
    Fastter.instance.onConnect = () {
      widget.confirmUser(Fastter.instance.bearer);
    };
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey,
        theme: primaryTheme,
        onGenerateRoute: onGenerateRoute,
        initialRoute: widget.frontPage.route,
        navigatorObservers: [
          analyticsObserver,
        ],
      );
}

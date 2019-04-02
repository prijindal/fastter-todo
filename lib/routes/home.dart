import 'package:redux/redux.dart';
import 'package:flutter/material.dart'
    show
        MaterialPageRoute,
        StatelessWidget,
        Route,
        RouteSettings,
        Scaffold,
        Text,
        Widget,
        MaterialApp,
        BuildContext,
        StatefulWidget,
        State,
        VoidCallback,
        required;
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/fastter/fastter.dart';
import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/settings.model.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import 'package:fastter_dart/store/state.dart';
import 'package:fastter_dart/store/user.dart';
import 'package:fastter_dart/models/todoreminder.model.dart';
import 'package:fastter_dart/models/notification.model.dart' show Notification;

import '../components/todolist.dart';

import '../helpers/navigator.dart';
import '../helpers/theme.dart';

import '../screens/generalsettings.dart';
import '../screens/profile.dart';
import '../screens/settings.dart';
import '../screens/todoedit.dart';
import '../screens/todos.dart';

class HomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _HomePage(
              projectSyncStart: () => store.dispatch(StartSync<Project>()),
              labelSyncStart: () => store.dispatch(StartSync<Label>()),
              todoSyncStart: () => store.dispatch(StartSync<Todo>()),
              todoCommentsSyncStart: () =>
                  store.dispatch(StartSync<TodoComment>()),
              todoRemindersSyncStart: () =>
                  store.dispatch(StartSync<TodoReminder>()),
              notificationsSyncStart: () =>
                  store.dispatch(StartSync<Notification>()),
              confirmUser: (bearer) =>
                  store.dispatch(ConfirmUserAction(bearer)),
              frontPage: store.state.user.user?.settings?.frontPage ??
                  FrontPage(
                    route: '/',
                    title: 'Inbox',
                  ),
            ),
      );
}

class _HomePage extends StatefulWidget {
  const _HomePage({
    @required this.labelSyncStart,
    @required this.projectSyncStart,
    @required this.todoSyncStart,
    @required this.todoCommentsSyncStart,
    @required this.todoRemindersSyncStart,
    @required this.notificationsSyncStart,
    @required this.confirmUser,
    @required this.frontPage,
  });

  final VoidCallback projectSyncStart;
  final VoidCallback labelSyncStart;
  final VoidCallback todoSyncStart;
  final VoidCallback todoCommentsSyncStart;
  final VoidCallback todoRemindersSyncStart;
  final VoidCallback notificationsSyncStart;
  final void Function(String) confirmUser;
  final FrontPage frontPage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  @override
  void initState() {
    super.initState();
    widget.todoSyncStart();
    widget.projectSyncStart();
    widget.todoCommentsSyncStart();
    widget.labelSyncStart();
    widget.todoRemindersSyncStart();
    widget.notificationsSyncStart();
    Fastter.instance.onConnect = () {
      widget.confirmUser(Fastter.instance.bearer);
    };
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute<void>(
        builder: (context) => InboxScreen(),
      );
    } else if (settings.name == '/all') {
      return MaterialPageRoute<void>(
        builder: (context) => AllTodosScreen(),
      );
    } else if (settings.name == '/today') {
      return MaterialPageRoute<void>(
        builder: (context) => TodayScreen(),
      );
    } else if (settings.name == '/7days') {
      return MaterialPageRoute<void>(
        builder: (context) => SevenDayScreen(),
      );
    } else if (settings.name == '/todos') {
      final Map<String, dynamic> arguments = settings.arguments;
      final filters = <String, dynamic>{};
      String title;
      if (arguments.containsKey('label')) {
        final Label label = arguments['label'];
        filters['label'] = label.id;
        title = label.title;
      }
      if (arguments.containsKey('project')) {
        final Project project = arguments['project'];
        filters['project'] = project.id;
        title = project.title;
      }
      return MaterialPageRoute<void>(
        builder: (context) => TodoList(
              filter: filters,
              title: title,
            ),
      );
    } else if (settings.name.startsWith('/todo/')) {
      final todoid = settings.name.split('/todo/')[1];
      return MaterialPageRoute<void>(
        builder: (context) => TodoEditScreenFromId(
              todoid: todoid,
            ),
      );
    } else if (settings.name == '/todo') {
      final Map<String, dynamic> arguments = settings.arguments;
      final Todo todo = arguments['todo'];
      return MaterialPageRoute<void>(
        builder: (context) => TodoEditScreen(
              todo: todo,
            ),
      );
    } else if (settings.name == '/settings') {
      return MaterialPageRoute<void>(builder: (context) => SettingsScreen());
    } else if (settings.name == '/settings/account') {
      return MaterialPageRoute<void>(builder: (context) => ProfileScreen());
    } else if (settings.name == '/settings/general') {
      return MaterialPageRoute<void>(
          builder: (context) => GeneralSettingsScreen());
    }
    return MaterialPageRoute<void>(
      builder: (context) => Scaffold(
            body: const Text('404'),
          ),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey,
        theme: primaryTheme,
        onGenerateRoute: _onGenerateRoute,
        initialRoute: widget.frontPage.route,
      );
}

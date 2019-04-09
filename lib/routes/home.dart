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
import 'package:fastter_dart/store/labels.dart';
import 'package:fastter_dart/store/projects.dart';
import 'package:fastter_dart/store/todocomments.dart';
import 'package:fastter_dart/store/todoreminders.dart';
import 'package:fastter_dart/store/todos.dart';
import 'package:fastter_dart/store/notifications.dart';
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
              projectSyncStart: () {
                final action = StartSync<Project>();
                store.dispatch(action);
                return action.completer.future;
              },
              labelSyncStart: () {
                final action = StartSync<Label>();
                store.dispatch(action);
                return action.completer.future;
              },
              todoSyncStart: () {
                final action = StartSync<Todo>();
                store.dispatch(action);
                return action.completer.future;
              },
              todoCommentsSyncStart: () =>
                  store.dispatch(StartSync<TodoComment>()),
              todoRemindersSyncStart: () =>
                  store.dispatch(StartSync<TodoReminder>()),
              notificationsSyncStart: () =>
                  store.dispatch(StartSync<Notification>()),
              confirmUser: (bearer) =>
                  store.dispatch(ConfirmUserAction(bearer)),
              initSubscriptions: () {
                fastterLabels.queries.initSubscriptions(store.dispatch);
                fastterProjects.queries.initSubscriptions(store.dispatch);
                fastterTodos.queries.initSubscriptions(store.dispatch);
                fastterTodoComments.queries.initSubscriptions(store.dispatch);
                fastterTodoReminders.queries.initSubscriptions(store.dispatch);
                fastterNotifications.queries.initSubscriptions(store.dispatch);
              },
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

class _HomePageState extends State<_HomePage> {
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

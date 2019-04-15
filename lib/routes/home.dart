import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
import 'package:fastter_dart/models/notification.model.dart'
    as NotificationModel;

import 'home/router.dart';

class HomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => HomePage(
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
                  store.dispatch(StartSync<NotificationModel.Notification>()),
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

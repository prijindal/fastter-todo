import 'package:fastter_dart/fastter/fastter.dart';
import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import 'package:fastter_dart/models/todoreminder.model.dart';
import 'package:fastter_dart/models/notification.model.dart';
import 'package:fastter_dart/store/todos.dart';
import 'package:fastter_dart/store/projects.dart';
import 'package:fastter_dart/store/labels.dart';
import 'package:fastter_dart/store/notifications.dart';
import 'package:fastter_dart/store/todocomments.dart';
import 'package:fastter_dart/store/todoreminders.dart';

void startSyncAll() {
  fastterTodos.dispatch(SetFetching<Todo>());
  fastterProjects.dispatch(SetFetching<Project>());
  fastterLabels.dispatch(SetFetching<Label>());
  fastterNotifications.dispatch(SetFetching<Notification>());
  fastterTodoComments.dispatch(SetFetching<TodoComment>());
  fastterTodoReminders.dispatch(SetFetching<TodoReminder>());
  Fastter.instance
      .request(
    SingleRequest(
      query: '''
            query {
              ${fastterTodos.queries.name}s {
                ...${fastterTodos.queries.name}
              }
              ${fastterProjects.queries.name}s {
                ...${fastterProjects.queries.name}
              }
              ${fastterLabels.queries.name}s {
                ...${fastterLabels.queries.name}
              }
              ${fastterNotifications.queries.name}s {
                ...${fastterNotifications.queries.name}
              }
              ${fastterTodoComments.queries.name}s {
                ...${fastterTodoComments.queries.name}
              }
              ${fastterTodoReminders.queries.name}s {
                ...${fastterTodoReminders.queries.name}
              }
            }
            ${fastterTodos.queries.fragment}
            ${fastterProjects.queries.fragment}
            ${fastterLabels.queries.fragment}
            ${fastterNotifications.queries.fragment}
            ${fastterTodoComments.queries.fragment}
            ${fastterTodoReminders.queries.fragment}
          ''',
    ),
  )
      .then((response) {
    if (response['${fastterTodos.queries.name}s'] != null) {
      final List<dynamic> todos = response['${fastterTodos.queries.name}s'];
      if (todos != null) {
        fastterTodos.dispatch(SyncEventCompleted<Todo>(
            todos.map<Todo>((dynamic d) => fastterTodos.fromJson(d)).toList()));
      }
      final List<dynamic> projects =
          response['${fastterProjects.queries.name}s'];
      if (projects != null) {
        fastterProjects.dispatch(SyncEventCompleted<Project>(projects
            .map<Project>((dynamic d) => fastterProjects.fromJson(d))
            .toList()));
      }
      final List<dynamic> labels = response['${fastterLabels.queries.name}s'];
      if (labels != null) {
        fastterLabels.dispatch(SyncEventCompleted<Label>(labels
            .map<Label>((dynamic d) => fastterLabels.fromJson(d))
            .toList()));
      }
      final List<dynamic> notifications =
          response['${fastterNotifications.queries.name}s'];
      if (notifications != null) {
        fastterNotifications.dispatch(SyncEventCompleted<Notification>(
            notifications
                .map<Notification>(
                    (dynamic d) => fastterNotifications.fromJson(d))
                .toList()));
      }
      final List<dynamic> todoComments =
          response['${fastterTodoComments.queries.name}s'];
      if (todoComments != null) {
        fastterTodoComments.dispatch(SyncEventCompleted<TodoComment>(
            todoComments
                .map<TodoComment>(
                    (dynamic d) => fastterTodoComments.fromJson(d))
                .toList()));
      }
      final List<dynamic> todoReminders =
          response['${fastterTodoReminders.queries.name}s'];
      if (todoReminders != null) {
        fastterTodoReminders.dispatch(SyncEventCompleted<TodoReminder>(
            todoReminders
                .map<TodoReminder>(
                    (dynamic d) => fastterTodoReminders.fromJson(d))
                .toList()));
      }
    }
  });
}

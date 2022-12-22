import '../fastter/fastter.dart';
import '../fastter/fastter_bloc.dart';
import '../models/label.model.dart';
import '../models/project.model.dart';
import '../models/todo.model.dart';
import '../models/todocomment.model.dart';
import '../models/todoreminder.model.dart';
import '../models/notification.model.dart';
import '../store/todos.dart';
import '../store/projects.dart';
import '../store/labels.dart';
import '../store/notifications.dart';
import '../store/todocomments.dart';
import '../store/todoreminders.dart';

void startSyncAll() {
  fastterTodos.add(SyncEventCompleted<Todo>([]));
  fastterProjects.add(SyncEventCompleted<Project>([]));
  fastterLabels.add(SyncEventCompleted<Label>([]));
  fastterNotifications.add(SyncEventCompleted<Notification>([]));
  fastterTodoComments.add(SyncEventCompleted<TodoComment>([]));
  fastterTodoReminders.add(SyncEventCompleted<TodoReminder>([]));
  // Fastter.instance
  //     .request(
  //   SingleRequest(
  //     query: '''
  //           query {
  //             ${fastterTodos.queries.name}s {
  //               ...${fastterTodos.queries.name}
  //             }
  //             ${fastterProjects.queries.name}s {
  //               ...${fastterProjects.queries.name}
  //             }
  //             ${fastterLabels.queries.name}s {
  //               ...${fastterLabels.queries.name}
  //             }
  //             ${fastterNotifications.queries.name}s {
  //               ...${fastterNotifications.queries.name}
  //             }
  //             ${fastterTodoComments.queries.name}s {
  //               ...${fastterTodoComments.queries.name}
  //             }
  //             ${fastterTodoReminders.queries.name}s {
  //               ...${fastterTodoReminders.queries.name}
  //             }
  //           }
  //           ${fastterTodos.queries.fragment}
  //           ${fastterProjects.queries.fragment}
  //           ${fastterLabels.queries.fragment}
  //           ${fastterNotifications.queries.fragment}
  //           ${fastterTodoComments.queries.fragment}
  //           ${fastterTodoReminders.queries.fragment}
  //         ''',
  //   ),
  // )
  //     .then((response) {
  //   if (response['${fastterTodos.queries.name}s'] != null) {
  //     final List<dynamic> todos = response['${fastterTodos.queries.name}s'];
  //     if (todos != null) {
  //       fastterTodos.add(SyncEventCompleted<Todo>(
  //           todos.map<Todo>((dynamic d) => fastterTodos.fromJson(d)).toList()));
  //     }
  //     final List<dynamic> projects =
  //         response['${fastterProjects.queries.name}s'];
  //     if (projects != null) {
  //       fastterProjects.add(SyncEventCompleted<Project>(projects
  //           .map<Project>((dynamic d) => fastterProjects.fromJson(d))
  //           .toList()));
  //     }
  //     final List<dynamic> labels = response['${fastterLabels.queries.name}s'];
  //     if (labels != null) {
  //       fastterLabels.add(SyncEventCompleted<Label>(labels
  //           .map<Label>((dynamic d) => fastterLabels.fromJson(d))
  //           .toList()));
  //     }
  //     final List<dynamic> notifications =
  //         response['${fastterNotifications.queries.name}s'];
  //     if (notifications != null) {
  //       fastterNotifications.add(SyncEventCompleted<Notification>(notifications
  //           .map<Notification>((dynamic d) => fastterNotifications.fromJson(d))
  //           .toList()));
  //     }
  //     final List<dynamic> todoComments =
  //         response['${fastterTodoComments.queries.name}s'];
  //     if (todoComments != null) {
  //       fastterTodoComments.add(SyncEventCompleted<TodoComment>(todoComments
  //           .map<TodoComment>((dynamic d) => fastterTodoComments.fromJson(d))
  //           .toList()));
  //     }
  //     final List<dynamic> todoReminders =
  //         response['${fastterTodoReminders.queries.name}s'];
  //     if (todoReminders != null) {
  //       fastterTodoReminders.add(SyncEventCompleted<TodoReminder>(todoReminders
  //           .map<TodoReminder>((dynamic d) => fastterTodoReminders.fromJson(d))
  //           .toList()));
  //     }
  //   }
  // });
}

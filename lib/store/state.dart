import '../models/base.model.dart';
import '../models/project.model.dart';
import '../models/todo.model.dart';
import '../models/todocomment.model.dart';
import '../models/user.model.dart';

class ClearAll {}

class AppState {
  AppState({
    this.user,
    this.rehydrated = false,
    this.todos = const ListState<Todo>(),
    this.projects = const ListState<Project>(),
    this.todoComments = const ListState<TodoComment>(),
    this.selectedTodos = const [],
  });

  factory AppState.fromJson(dynamic json) {
    if (json != null && json['user'] != null) {
      return AppState(
        user: UserState.fromJson(json['user']),
        todos: ListState<Todo>(
          items: json['todos'] != null && json['todos']['items'] != null
              ? (json['todos']['items'] as List<dynamic>)
                  .map<Todo>((dynamic t) => Todo.fromJson(t))
                  .toList()
              : [],
        ),
        projects: ListState<Project>(
          items: json['projects'] != null && json['projects']['items'] != null
              ? (json['projects']['items'] as List<dynamic>)
                  .map<Project>((dynamic t) => Project.fromJson(t))
                  .toList()
              : [],
        ),
        todoComments: ListState<TodoComment>(
          items: json['todoComments'] != null &&
                  json['todoComments']['items'] != null
              ? (json['todoComments']['items'] as List<dynamic>)
                  .map<TodoComment>((dynamic t) => TodoComment.fromJson(t))
                  .toList()
              : [],
        ),
      );
    } else {
      return AppState();
    }
  }

  bool rehydrated;
  UserState user;
  ListState<Todo> todos;
  ListState<Project> projects;
  ListState<TodoComment> todoComments;

  // Temporary state of the app
  List<String> selectedTodos = [];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user != null ? user.toJson() : <String, dynamic>{},
        'todos': todos.toJson(),
        'projects': projects.toJson(),
        'todoComments': todoComments.toJson(),
      };

  @override
  String toString() {
    final json = toJson();
    json.addAll(<String, dynamic>{
      'rehydrated': rehydrated,
    });
    return json.toString();
  }
}

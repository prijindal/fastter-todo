import '../models/user.model.dart';
import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../models/project.model.dart';

class ClearAll {}

class AppState {
  AppState({
    this.user,
    this.rehydrated = false,
    ListState<Todo> todos,
    ListState<Project> projects,
    this.selectedTodos = const [],
  }) {
    if (todos == null) {
      todos = ListState<Todo>();
    }
    if (projects == null) {
      projects = ListState<Project>();
    }
    this.todos = todos;
    this.projects = projects;
  }

  bool rehydrated;
  UserState user;
  ListState<Todo> todos;
  ListState<Project> projects;

  // Temporary state of the app
  List<String> selectedTodos = [];

  static AppState fromJson(dynamic json) {
    if (json != null && json['user'] != null) {
      return AppState(
        user: UserState.fromJson(json['user']),
        todos: ListState<Todo>(
          items: json['todos'] != null && json['todos']['items'] != null
              ? (json['todos']['items'] as List<dynamic>)
                  .map<Todo>((t) => Todo.fromJson(t))
                  .toList()
              : [],
        ),
        projects: ListState<Project>(
          items: json['projects'] != null && json['projects']['items'] != null
              ? (json['projects']['items'] as List<dynamic>)
                  .map<Project>((t) => Project.fromJson(t))
                  .toList()
              : [],
        ),
      );
    } else {
      return AppState();
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user != null ? user.toJson() : <String, dynamic>{},
        'todos': todos.toJson(),
        'projects': projects.toJson(),
      };

  @override
  String toString() {
    final Map<String, dynamic> json = toJson();
    json.addAll(<String, dynamic>{
      'rehydrated': rehydrated,
    });
    return json.toString();
  }
}

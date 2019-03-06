import '../models/user.model.dart';
import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../models/project.model.dart';

class AppState {
  AppState({
    this.user,
    this.bearer,
    this.rehydrated = false,
    this.todos,
    this.projects,
  });

  bool rehydrated;
  User user;
  String bearer;
  ListState<Todo> todos;
  ListState<Project> projects;

  static AppState fromJson(dynamic json) {
    if (json != null && json['user'] != null) {
      return AppState(
        user: User.fromJson(json['user']),
        bearer: json['bearer'],
        todos: ListState<Todo>(
          fetching: false,
          items: json['todos'] != null && json['todos']['items'] != null
              ? (json['todos']['items'] as List<dynamic>)
                  .map<Todo>((t) => Todo.fromJson(t))
                  .toList()
              : [],
        ),
        projects: ListState<Project>(
          fetching: false,
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
        'bearer': bearer,
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

import 'package:meta/meta.dart';
import '../models/user.model.dart';
import 'currentuser.dart';
import 'bearer.dart';
import 'todos.dart';
import 'projects.dart';
import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../models/project.model.dart';
import './state.dart';

class InitStateReset {
  InitStateReset({
    @required this.user,
    @required this.bearer,
    this.todos = const ListState<Todo>(),
    this.projects = const ListState<Project>(),
  });
  final User user;
  final String bearer;
  final ListState<Todo> todos;
  final ListState<Project> projects;
}

AppState appStateReducer(AppState state, dynamic action) {
  if (action is InitStateReset) {
    return AppState(
      user: action.user,
      bearer: action.bearer,
      rehydrated: true,
      todos: action.todos,
      projects: action.projects,
    );
  }
  return AppState(
    rehydrated: state.rehydrated,
    user: userReducer(state.user, action),
    bearer: bearerReducer(state.bearer, action),
    todos: fastterTodos.reducer(state.todos, action),
    projects: fastterProjects.reducer(state.projects, action),
  );
}

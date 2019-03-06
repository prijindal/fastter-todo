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
  InitStateReset(this.user, this.bearer);
  final User user;
  final String bearer;
}

AppState appStateReducer(AppState state, dynamic action) {
  if (action is InitStateReset) {
    return AppState(
      user: action.user,
      bearer: action.bearer,
      rehydrated: true,
      todos: ListState<Todo>(),
      projects: ListState<Project>(),
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

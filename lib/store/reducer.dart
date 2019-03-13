import 'package:meta/meta.dart';

import '../models/base.model.dart';
import '../models/project.model.dart';
import '../models/todo.model.dart';
import '../models/todocomment.model.dart';
import '../models/user.model.dart';
import './state.dart';

import 'projects.dart';
import 'selectedtodos.dart';
import 'todos.dart';
import 'todocomments.dart';
import 'user.dart';

class InitStateReset {
  InitStateReset({
    @required this.user,
    this.todos = const ListState<Todo>(),
    this.projects = const ListState<Project>(),
    this.todoComments = const ListState<TodoComment>(),
  });
  final UserState user;
  final ListState<Todo> todos;
  final ListState<Project> projects;
  final ListState<TodoComment> todoComments;
}

AppState appStateReducer(AppState state, dynamic action) {
  if (action is InitStateReset) {
    return AppState(
      user: action.user,
      rehydrated: true,
      todos: action.todos,
      projects: action.projects,
      todoComments: action.todoComments,
    );
  }
  if (action is ClearAll) {
    return AppState(
      user: UserState(bearer: null, user: null),
      rehydrated: true,
      todos: const ListState<Todo>(),
      projects: const ListState<Project>(),
      todoComments: const ListState<TodoComment>(),
    );
  }
  return AppState(
    rehydrated: state.rehydrated,
    user: userReducer(state.user, action),
    todos: fastterTodos.reducer(state.todos, action),
    projects: fastterProjects.reducer(state.projects, action),
    todoComments: fastterTodoComments.reducer(state.todoComments, action),
    selectedTodos: selectedTodos(state.selectedTodos, action),
  );
}

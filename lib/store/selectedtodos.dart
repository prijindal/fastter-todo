import 'package:bloc/bloc.dart';

class SelectedTodoEvent {}

class ToggleSelectTodoEvent extends SelectedTodoEvent {
  ToggleSelectTodoEvent(this.todoid);

  final String todoid;
}

class SelectTodoEvent extends SelectedTodoEvent {
  SelectTodoEvent(this.todoid);

  final String todoid;
}

class UnSelectTodoEvent extends SelectedTodoEvent {
  UnSelectTodoEvent(this.todoid);

  final String todoid;
}

class SelectedTodosBloc extends Bloc<SelectedTodoEvent, List<String>> {
  SelectedTodosBloc():super([]) {
    on((SelectedTodoEvent event, emit) {
    if (event is ToggleSelectTodoEvent) {
      if (state.contains(event.todoid)) {
        emit(List<String>.from(state)..remove(event.todoid));
      } else {
        emit(List<String>.from(state)..add(event.todoid));
      }
    } else if (event is SelectTodoEvent) {
      if (!state.contains(event.todoid)) {
        emit(List<String>.from(state)..add(event.todoid));
      }
    } else if (event is UnSelectTodoEvent) {
      if (state.contains(event.todoid)) {
        emit(List<String>.from(state)..remove(event.todoid));
      }
    }
    });
  }
}

SelectedTodosBloc selectedTodosBloc = SelectedTodosBloc();

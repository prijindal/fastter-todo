import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'projectdropdown.dart';

import '../models/base.model.dart';
import '../helpers/navigator.dart';
import '../helpers/todouihelpers.dart';
import '../models/todo.model.dart';
import '../models/project.model.dart';
import '../fastter/fastter_action.dart';
import '../store/state.dart';

import '../screens/todoedit.dart';

class TodoEditBar extends StatelessWidget {
  TodoEditBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        void onMarkCompleted() {
          store.state.selectedTodos.forEach((todoid) {
            if (store.state.todos.items.isNotEmpty) {
              Todo todo = store.state.todos.items
                  .singleWhere((item) => item.id == todoid);
              if (todo != null) {
                todo.completed = true;
                store.dispatch(UpdateItem<Todo>(todoid, todo));
              }
            }
          });
        }

        void onChangeDate(DateTime date) {
          store.state.selectedTodos.forEach((todoid) {
            if (store.state.todos.items.isNotEmpty) {
              Todo todo = store.state.todos.items
                  .singleWhere((item) => item.id == todoid);
              if (todo != null) {
                todo.dueDate = date;
                store.dispatch(UpdateItem<Todo>(todoid, todo));
              }
            }
          });
        }

        void onChangeProject(Project project) {
          store.state.selectedTodos.forEach((todoid) {
            if (store.state.todos.items.isNotEmpty) {
              Todo todo = store.state.todos.items
                  .singleWhere((item) => item.id == todoid);
              if (todo != null) {
                todo.project = project;
                store.dispatch(UpdateItem<Todo>(todoid, todo));
              }
            }
          });
        }

        return _TodoEditBar(
          selectedTodos: store.state.selectedTodos,
          onMarkCompleted: onMarkCompleted,
          todos: store.state.todos,
          onChangeDate: onChangeDate,
          onChangeProject: onChangeProject,
        );
      },
    );
  }
}

class _TodoEditBar extends StatelessWidget {
  final List<String> selectedTodos;
  final ListState<Todo> todos;
  final VoidCallback onMarkCompleted;
  final void Function(DateTime) onChangeDate;
  final void Function(Project) onChangeProject;

  _TodoEditBar({
    Key key,
    @required this.todos,
    @required this.selectedTodos,
    @required this.onMarkCompleted,
    @required this.onChangeDate,
    @required this.onChangeProject,
  }) : super(key: key);

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime selectedDate = await todoSelectDate(context);
    onChangeDate(selectedDate);
  }

  Widget _buildMarkCompletedButton() {
    return IconButton(
      icon: Icon(Icons.check),
      onPressed: onMarkCompleted,
    );
  }

  Widget _buildChangeDateButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.calendar_today,
        color: Theme.of(context).accentColor,
      ),
      onPressed: () => _showDatePicker(context),
    );
  }

  Widget _buildEditButton() {
    String todoid = selectedTodos[0];
    if (todos.items.isNotEmpty) {
      Todo todo = todos.items.singleWhere((item) => item.id == todoid);
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          mainNavigatorKey.currentState.push(
            MaterialPageRoute(
              builder: (context) => TodoEditScreen(
                    todo: todo,
                  ),
            ),
          );
        },
      );
    } else {
      return null;
    }
  }

  Widget _buildChangeProjectButton() {
    return ProjectDropdown(
      onSelected: onChangeProject,
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    if (selectedTodos.length == 1) {
      return <Widget>[
        _buildChangeDateButton(context),
        _buildEditButton(),
        _buildChangeProjectButton(),
      ];
    }
    return <Widget>[
      _buildMarkCompletedButton(),
      _buildChangeDateButton(context),
      _buildChangeProjectButton(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildButtons(context),
        ),
      ),
    );
  }
}

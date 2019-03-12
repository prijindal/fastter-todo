import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../fastter/fastter_action.dart';
import '../helpers/navigator.dart';
import '../helpers/todouihelpers.dart';
import '../models/base.model.dart';
import '../models/project.model.dart';
import '../models/todo.model.dart';
import '../screens/todoedit.dart';
import '../store/state.dart';

import 'projectdropdown.dart';

class TodoEditBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          void onMarkCompleted() {
            for (final todoid in store.state.selectedTodos) {
              if (store.state.todos.items.isNotEmpty) {
                final todo = store.state.todos.items
                    .singleWhere((item) => item.id == todoid);
                if (todo != null) {
                  todo.completed = true;
                  store.dispatch(UpdateItem<Todo>(todoid, todo));
                }
              }
            }
          }

          void onChangeDate(DateTime date) {
            for (final todoid in store.state.selectedTodos) {
              if (store.state.todos.items.isNotEmpty) {
                final todo = store.state.todos.items
                    .singleWhere((item) => item.id == todoid);
                if (todo != null) {
                  todo.dueDate = date;
                  store.dispatch(UpdateItem<Todo>(todoid, todo));
                }
              }
            }
          }

          void onChangeProject(Project project) {
            for (final todoid in store.state.selectedTodos) {
              if (store.state.todos.items.isNotEmpty) {
                final todo = store.state.todos.items
                    .singleWhere((item) => item.id == todoid);
                if (todo != null) {
                  todo.project = project;
                  store.dispatch(UpdateItem<Todo>(todoid, todo));
                }
              }
            }
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

class _TodoEditBar extends StatelessWidget {
  const _TodoEditBar({
    @required this.todos,
    @required this.selectedTodos,
    @required this.onMarkCompleted,
    @required this.onChangeDate,
    @required this.onChangeProject,
    Key key,
  }) : super(key: key);

  final List<String> selectedTodos;
  final ListState<Todo> todos;
  final VoidCallback onMarkCompleted;
  final void Function(DateTime) onChangeDate;
  final void Function(Project) onChangeProject;

  Future<void> _showDatePicker(BuildContext context) async {
    final selectedDate = await todoSelectDate(context);
    onChangeDate(selectedDate);
  }

  Widget _buildMarkCompletedButton() => IconButton(
        icon: const Icon(Icons.check),
        onPressed: onMarkCompleted,
      );

  Widget _buildChangeDateButton(BuildContext context) => IconButton(
        icon: Icon(
          Icons.calendar_today,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () => _showDatePicker(context),
      );

  Widget _buildEditButton() {
    final todoid = selectedTodos[0];
    if (todos.items.isNotEmpty) {
      final todo = todos.items.singleWhere((item) => item.id == todoid);
      return IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          mainNavigatorKey.currentState.push<void>(
            MaterialPageRoute<void>(
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

  Widget _buildChangeProjectButton() => ProjectDropdown(
        onSelected: onChangeProject,
      );

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
  Widget build(BuildContext context) => Material(
        elevation: 20,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildButtons(context),
          ),
        ),
      );
}

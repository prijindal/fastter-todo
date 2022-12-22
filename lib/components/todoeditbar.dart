import '../store/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fastter/fastter_bloc.dart';
import '../models/base.model.dart';
import '../models/label.model.dart';
import '../store/selectedtodos.dart';
import '../models/project.model.dart';
import '../models/todo.model.dart';

import '../components/prioritydialog.dart';
import '../helpers/todouihelpers.dart';
import '../screens/todocomments.dart';
import '../screens/todoedit.dart';
import '../screens/todoreminders.dart';
import '../screens/todosubtasks.dart';

import 'labelselector.dart';
import 'projectdropdown.dart';

class TodoEditBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<SelectedTodosBloc, List<String>>(
        bloc: selectedTodosBloc,
        builder: (context, selectedTodos) =>
            BlocBuilder<FastterBloc<Todo>, ListState<Todo>>(
          bloc: fastterTodos,
          builder: (context, state) {
            void _unSelectAllTodos() {
              for (final todoid in selectedTodos) {
                selectedTodosBloc.add(UnSelectTodoEvent(todoid));
              }
            }

            Future<void> _onMarkCompleted() async {
              final body = <String, Todo>{};
              for (final todoid in selectedTodos) {
                if (state.items.isNotEmpty) {
                  final todo =
                      state.items.singleWhere((item) => item.id == todoid);
                  if (todo != null) {
                    todo.completed = true;
                    body[todoid] = todo;
                  }
                }
              }
              fastterTodos.add(UpdateManyEvent<Todo>(body));
              _unSelectAllTodos();
            }

            Future<void> _onChangeDate(DateTime date) async {
              final body = <String, Todo>{};
              for (final todoid in selectedTodos) {
                if (state.items.isNotEmpty) {
                  final todo =
                      state.items.singleWhere((item) => item.id == todoid);
                  if (todo != null) {
                    todo.dueDate = date;
                    body[todoid] = todo;
                  }
                }
              }
              fastterTodos.add(UpdateManyEvent<Todo>(body));
              _unSelectAllTodos();
            }

            Future<void> _onChangeProject(Project? project) async {
              final body = <String, Todo>{};
              for (final todoid in selectedTodos) {
                if (state.items.isNotEmpty) {
                  final todo =
                      state.items.singleWhere((item) => item.id == todoid);
                  if (todo != null) {
                    todo.project = project;
                    body[todoid] = todo;
                  }
                }
              }
              fastterTodos.add(UpdateManyEvent<Todo>(body));
              _unSelectAllTodos();
            }

            Future<void> _onChangeLabels(List<Label> labels) async {
              final body = <String, Todo>{};
              for (final todoid in selectedTodos) {
                if (state.items.isNotEmpty) {
                  final todo =
                      state.items.singleWhere((item) => item.id == todoid);
                  if (todo != null) {
                    todo.labels = labels;
                    body[todoid] = todo;
                  }
                }
              }
              fastterTodos.add(UpdateManyEvent<Todo>(body));
              _unSelectAllTodos();
            }

            Future<void> _onChangePriority(int priority) async {
              final body = <String, Todo>{};
              for (final todoid in selectedTodos) {
                if (state.items.isNotEmpty) {
                  final todo =
                      state.items.singleWhere((item) => item.id == todoid);
                  if (todo != null) {
                    todo.priority = priority;
                    body[todoid] = todo;
                  }
                }
              }
              fastterTodos.add(UpdateManyEvent<Todo>(body));
              _unSelectAllTodos();
            }

            Future<void> _deleteSelected() async {
              for (final todoid in selectedTodos) {
                final action = DeleteEvent<Todo>(todoid);
                fastterTodos.add(action);
              }
              _unSelectAllTodos();
            }

            return _TodoEditBar(
              selectedTodos: selectedTodos,
              todos: state,
              onMarkCompleted: _onMarkCompleted,
              onChangeDate: _onChangeDate,
              onChangeProject: _onChangeProject,
              onChangeLabels: _onChangeLabels,
              onChangePriority: _onChangePriority,
              deleteSelected: _deleteSelected,
            );
          },
        ),
      );
}

class _TodoEditBar extends StatelessWidget {
  const _TodoEditBar({
    required this.todos,
    required this.selectedTodos,
    required this.onMarkCompleted,
    required this.onChangeDate,
    required this.onChangeProject,
    required this.onChangePriority,
    required this.onChangeLabels,
    required this.deleteSelected,
  });

  final List<String> selectedTodos;
  final ListState<Todo> todos;
  final VoidCallback onMarkCompleted;
  final void Function(DateTime) onChangeDate;
  final void Function(Project?) onChangeProject;
  final void Function(int) onChangePriority;
  final void Function(List<Label>) onChangeLabels;
  final VoidCallback deleteSelected;

  Future<void> _showDatePicker(BuildContext context) async {
    final todoid = selectedTodos[0];
    final todo = todos.items.singleWhere((item) => item.id == todoid);
    // final selectedDate = await todoSelectDate(context, todo.dueDate);
    // if (selectedDate != null) {
    //   onChangeDate(selectedDate.dateTime);
    // }
  }

  Widget _buildMarkCompletedButton() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: IconButton(
          icon: const Icon(Icons.check),
          onPressed: onMarkCompleted,
          tooltip: 'Completed',
        ),
      );

  Widget _buildChangeDateButton(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: IconButton(
          icon: Icon(
            Icons.calendar_today,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () => _showDatePicker(context),
          tooltip: 'Due Date',
        ),
      );

  Widget _buildEditButton(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (context) {
                  final todoid = selectedTodos[0];
                  final todo =
                      todos.items.singleWhere((item) => item.id == todoid);
                  return TodoEditScreen(
                    todo: todo,
                  );
                },
              ),
            );
          },
          tooltip: 'Edit',
        ),
      );

  Widget _buildCommentButton(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: IconButton(
          icon: const Icon(Icons.comment),
          onPressed: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (context) {
                  final todoid = selectedTodos[0];
                  final todo =
                      todos.items.singleWhere((item) => item.id == todoid);
                  return TodoCommentsScreen(
                    todo: todo,
                  );
                },
              ),
            );
          },
          tooltip: 'Comments',
        ),
      );

  Widget _buildReminderButton(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: IconButton(
          icon: const Icon(Icons.alarm),
          onPressed: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (context) {
                  final todoid = selectedTodos[0];
                  final todo =
                      todos.items.singleWhere((item) => item.id == todoid);
                  return TodoRemindersScreen(
                    todo: todo,
                  );
                },
              ),
            );
          },
          tooltip: 'Reminders',
        ),
      );

  Widget _buildSubtaskButton(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: IconButton(
          icon: const Icon(Icons.format_strikethrough),
          onPressed: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (context) {
                  final todoid = selectedTodos[0];
                  final todo =
                      todos.items.singleWhere((item) => item.id == todoid);
                  return TodoSubtasks(
                    todo: todo,
                  );
                },
              ),
            );
          },
          tooltip: 'Subtasks',
        ),
      );
  Widget _buildDeleteButton(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Are you sure'),
                content: Text('This will delete ${selectedTodos.length} tasks'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      deleteSelected();
                    },
                  ),
                ],
              ),
            );
          },
          tooltip: 'Delete',
        ),
      );

  void _onChangeLabels(dynamic data) {
    if (data is List<Label>) {
      onChangeLabels(data);
    }
  }

  Future<void> _selectPriority(BuildContext context) async {
    final priority = await showPriorityDialog(context);
    if (priority != null) {
      onChangePriority(priority);
    }
  }

  Widget _buildSelectLabelsButton() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: LabelSelector(
          onSelected: _onChangeLabels,
          selectedLabels: todos.items.isNotEmpty && selectedTodos.isNotEmpty
              ? todos.items
                  .singleWhere((item) => item.id == selectedTodos[0])
                  .labels
              : [],
        ),
      );

  Widget _buildChangeProjectButton() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: ProjectDropdown(
          onSelected: onChangeProject,
          selectedProject: todos.items.isNotEmpty && selectedTodos.isNotEmpty
              ? todos.items
                  .singleWhere((item) => item.id == selectedTodos[0])
                  .project
              : null,
        ),
      );

  Widget _buildChangePriorityButton(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: IconButton(
          icon: const Icon(Icons.priority_high),
          onPressed: () => _selectPriority(context),
          tooltip: 'Priority',
        ),
      );

  List<Widget> _buildButtons(BuildContext context) {
    if (selectedTodos.length <= 1) {
      return <Widget>[
        _buildChangeDateButton(context),
        _buildEditButton(context),
        _buildChangeProjectButton(),
        _buildCommentButton(context),
        _buildSelectLabelsButton(),
        _buildChangePriorityButton(context),
        _buildReminderButton(context),
        _buildSubtaskButton(context),
        _buildDeleteButton(context),
      ];
    }
    return <Widget>[
      _buildMarkCompletedButton(),
      _buildChangeDateButton(context),
      _buildChangeProjectButton(),
      _buildSelectLabelsButton(),
      _buildChangePriorityButton(context),
      _buildDeleteButton(context),
    ];
  }

  Future<bool> _onWillPop() async {
    if (selectedTodos.isEmpty) {
      return true;
    }
    for (final id in selectedTodos) {
      selectedTodosBloc.add(UnSelectTodoEvent(id));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          height: 60,
          // width: _width(context) - 4.0,
          child: Center(
            child: Card(
              elevation: 20,
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: _buildButtons(context),
                ),
              ),
            ),
          ),
        ),
      );
}

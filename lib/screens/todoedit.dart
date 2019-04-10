import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import 'package:fastter_dart/models/todoreminder.model.dart';
import 'package:fastter_dart/store/selectedtodos.dart';
import 'package:fastter_dart/store/state.dart';

import '../components/labelselector.dart';
import '../components/prioritydialog.dart';
import '../components/projectdropdown.dart';
import '../helpers/theme.dart';
import '../helpers/todouihelpers.dart';
import 'todocomments.dart';
import 'todoreminders.dart';

class TodoEditScreenFromId extends StatelessWidget {
  const TodoEditScreenFromId({@required this.todoid});

  final String todoid;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => TodoEditScreen(
              todo: store.state.todos.items
                  .singleWhere((todo) => todo.id == todoid),
            ),
      );
}

class TodoEditScreen extends StatelessWidget {
  const TodoEditScreen({
    @required this.todo,
    Key key,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _TodoEditScreen(
              todo: todo,
              projects: store.state.projects,
              labels: store.state.labels,
              todoComments: ListState<TodoComment>(
                items: store.state.todoComments.items
                    .where((todocomment) =>
                        todocomment.todo != null &&
                        todocomment.todo.id == todo.id)
                    .toList(),
              ),
              todoReminders: ListState<TodoReminder>(
                items: store.state.todoReminders.items
                    .where((todoreminder) =>
                        todoreminder.todo != null &&
                        todoreminder.todo.id == todo.id &&
                        todoreminder.completed == false)
                    .toList(),
              ),
              updateTodo: (updated) =>
                  store.dispatch(UpdateItem<Todo>(todo.id, updated)),
              deleteTodo: () {
                store.dispatch(UnSelectTodo(todo.id));
                store.dispatch(DeleteItem<Todo>(todo.id));
              },
            ),
      );
}

class _TodoEditScreen extends StatefulWidget {
  const _TodoEditScreen({
    @required this.todo,
    @required this.projects,
    @required this.labels,
    @required this.todoComments,
    @required this.todoReminders,
    @required this.updateTodo,
    @required this.deleteTodo,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final ListState<Project> projects;
  final ListState<Label> labels;
  final ListState<TodoComment> todoComments;
  final ListState<TodoReminder> todoReminders;
  final void Function(Todo) updateTodo;
  final VoidCallback deleteTodo;

  @override
  __TodoEditScreenState createState() => __TodoEditScreenState();
}

enum _PopupAction { delete }

class __TodoEditScreenState extends State<_TodoEditScreen> {
  final double headerHeight = 120;
  final TextEditingController _titleInputController = TextEditingController();
  Project _project;
  List<Label> _labels;
  DateTime _dueDate;
  int _priority;

  @override
  void initState() {
    super.initState();
    _titleInputController.text = widget.todo.title;
    _project = widget.todo.project;
    _labels = widget.todo.labels;
    _dueDate = widget.todo.dueDate;
    _priority = widget.todo.priority;
  }

  void _onSelectProject(Project selectedproject) {
    setState(() {
      _project = selectedproject;
    });
  }

  void _onSelectLabels(dynamic selectedlabels) {
    if (selectedlabels is List<Label>) {
      setState(() {
        _labels = selectedlabels;
      });
    }
  }

  void _onSave() {
    if (_dueDate != null) {
      _dueDate = DateTime(_dueDate.year, _dueDate.month, _dueDate.day, 0, 0, 0);
    }
    final todo = Todo(
      id: widget.todo.id,
      title: _titleInputController.text,
      dueDate: _dueDate,
      project: _project,
      labels: _labels,
      completed: widget.todo.completed,
      createdAt: widget.todo.createdAt,
      updatedAt: widget.todo.updatedAt,
      priority: _priority,
    );
    widget.updateTodo(todo);
    Navigator.of(context).pop();
  }

  Future<void> _selectPriority() async {
    final priority = await showPriorityDialog(context);
    if (priority != null) {
      setState(() {
        _priority = priority;
      });
    }
  }

  void _selectDate() {
    todoSelectDate(context, _dueDate).then((dueDate) {
      setState(() {
        if (dueDate != null) {
          _dueDate = dueDate.dateTime;
        }
      });
    });
  }

  void _openComments() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => TodoCommentsScreen(
              todo: widget.todo,
            ),
      ),
    );
  }

  void _openReminders() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => TodoRemindersScreen(
              todo: widget.todo,
            ),
      ),
    );
  }

  void _delete() {
    widget.deleteTodo();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: <Widget>[
            PopupMenuButton<_PopupAction>(
              onSelected: (value) {
                if (value == _PopupAction.delete) {
                  _delete();
                }
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                    const PopupMenuItem<_PopupAction>(
                      child: Text('Delete'),
                      value: _PopupAction.delete,
                    )
                  ],
            )
          ],
        ),
        body: Stack(
          children: [
            ListView(
              children: <Widget>[
                Container(
                  height: headerHeight,
                  color: Theme.of(context).primaryColor,
                  child: AnimatedTheme(
                    data: whiteTheme,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          child: TextField(
                            controller: _titleInputController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Task',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ProjectDropdown(
                  expanded: true,
                  selectedProject: _project,
                  onSelected: _onSelectProject,
                ),
                LabelSelector(
                  expanded: true,
                  selectedLabels: _labels,
                  onSelected: _onSelectLabels,
                ),
                ListTile(
                  leading: const Icon(Icons.priority_high),
                  title: const Text('Priority'),
                  subtitle: _priority == null
                      ? null
                      : Text('Priority ${_priority.toString()}'),
                  onTap: _selectPriority,
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Due Date'),
                  subtitle: _dueDate == null
                      ? null
                      : Text(dueDateFormatter(_dueDate)),
                  onTap: _selectDate,
                ),
                ListTile(
                  leading: const Icon(Icons.comment),
                  title: const Text('Comments'),
                  subtitle: widget.todoComments.items.isEmpty
                      ? const Text('No Comments')
                      : Text('${widget.todoComments.items.length} Comments'),
                  onTap: _openComments,
                ),
                ListTile(
                  leading: const Icon(Icons.alarm),
                  title: const Text('Reminders'),
                  subtitle: widget.todoReminders.items.isEmpty
                      ? const Text('No Reminders')
                      : Text('${widget.todoReminders.items.length} Reminders'),
                  onTap: _openReminders,
                )
              ],
            ),
            Positioned(
              right: 48,
              top: headerHeight - 32.0,
              child: FloatingActionButton(
                child: const Icon(Icons.send),
                onPressed: _onSave,
              ),
            )
          ],
        ),
      );
}

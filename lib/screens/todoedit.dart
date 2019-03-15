import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/projectdropdown.dart';
import 'package:fastter_dart/fastter/fastter_action.dart';
import '../helpers/theme.dart';
import '../helpers/todouihelpers.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import '../screens/todocomments.dart';
import 'package:fastter_dart/store/selectedtodos.dart';
import 'package:fastter_dart/store/state.dart';

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
              todoComments: ListState<TodoComment>(
                items: store.state.todoComments.items
                    .where((todocomment) =>
                        todocomment.todo != null &&
                        todocomment.todo.id == todo.id)
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
    @required this.todoComments,
    @required this.updateTodo,
    @required this.deleteTodo,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final ListState<Project> projects;
  final ListState<TodoComment> todoComments;
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
  DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _titleInputController.text = widget.todo.title;
    _project = widget.todo.project;
    _dueDate = widget.todo.dueDate;
  }

  void _onSelectProject(Project selectedproject) {
    setState(() {
      _project = selectedproject;
    });
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
      completed: widget.todo.completed,
      createdAt: widget.todo.createdAt,
      updatedAt: widget.todo.updatedAt,
    );
    widget.updateTodo(todo);
    Navigator.of(context).pop();
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TodoCommentsScreen(
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
                    PopupMenuItem<_PopupAction>(
                      child: const Text('Delete'),
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
                      ? Text('No Comments')
                      : Text('${widget.todoComments.items.length} Comments'),
                  onTap: _openComments,
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

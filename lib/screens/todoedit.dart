import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../models/project.model.dart';
import '../store/state.dart';
import '../fastter/fastter_action.dart';
import '../helpers/todouihelpers.dart';
import '../components/hexcolor.dart';
import '../store/selectedtodos.dart';
import '../helpers/theme.dart';
import '../helpers/todouihelpers.dart';
import '../components/projectdropdown.dart';

class TodoEditScreen extends StatelessWidget {
  final Todo todo;

  TodoEditScreen({
    Key key,
    @required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _TodoEditScreen(
            todo: todo,
            projects: store.state.projects,
            updateTodo: (Todo updated) {
              updated.loading = true;
              store.dispatch(UpdateItem<Todo>(todo.id, updated));
            },
            deleteTodo: () {
              store.dispatch(UnSelectTodo(todo.id));
              store.dispatch(DeleteItem<Todo>(todo.id));
            });
      },
    );
  }
}

class _TodoEditScreen extends StatefulWidget {
  final Todo todo;
  final ListState<Project> projects;
  final void Function(Todo) updateTodo;
  final VoidCallback deleteTodo;
  _TodoEditScreen({
    Key key,
    @required this.todo,
    @required this.projects,
    @required this.updateTodo,
    @required this.deleteTodo,
  }) : super(key: key);

  __TodoEditScreenState createState() => __TodoEditScreenState();
}

enum _PopupAction { delete }

class __TodoEditScreenState extends State<_TodoEditScreen> {
  final double headerHeight = 120.0;
  TextEditingController _titleInputController = TextEditingController();
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
      this._project = selectedproject;
    });
  }

  void _onSave() {
    _dueDate =
        new DateTime(_dueDate.year, _dueDate.month, _dueDate.day, 0, 0, 0);
    Todo todo = Todo(
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
    Future<DateTime> selectedDate = todoSelectDate(context, _dueDate);
    selectedDate.then((dueDate) {
      setState(() {
        _dueDate = dueDate;
      });
    });
  }

  void _delete() {
    widget.deleteTodo();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          PopupMenuButton<_PopupAction>(
            onSelected: (_PopupAction value) {
              if (value == _PopupAction.delete) {
                _delete();
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
                  PopupMenuItem<_PopupAction>(
                    child: Text("Delete"),
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
                        margin: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8.0),
                        child: TextField(
                          controller: _titleInputController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Task",
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
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
                leading: Icon(Icons.calendar_today),
                title: Text("Due Date"),
                subtitle:
                    _dueDate == null ? null : Text(dueDateFormatter(_dueDate)),
                onTap: _selectDate,
              )
            ],
          ),
          Positioned(
            right: 48.0,
            top: headerHeight - 32.0,
            child: FloatingActionButton(
              child: Icon(Icons.arrow_right),
              onPressed: _onSave,
            ),
          )
        ],
      ),
    );
  }
}
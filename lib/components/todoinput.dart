import 'dart:math';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/todo.model.dart';
import '../models/project.model.dart';
import './projectdropdown.dart';
import '../fastter/fastter_action.dart';
import '../store/state.dart';

class TodoInput extends StatelessWidget {
  TodoInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _TodoInput(
          addTodo: (todo) => store.dispatch(AddItem<Todo>(todo)),
        );
      },
    );
  }
}

class _TodoInput extends StatefulWidget {
  final void Function(Todo todo) addTodo;

  _TodoInput({
    Key key,
    @required this.addTodo,
  }) : super(key: key);

  _TodoInputState createState() => _TodoInputState();
}

class _TodoInputState extends State<_TodoInput> {
  TextEditingController titleInputController = TextEditingController(text: "");
  DateTime dueDate = DateTime.now();
  Project project;

  _onSave() {
    Todo todo = Todo(
      title: titleInputController.text,
      dueDate: dueDate,
      project: project,
    );
    titleInputController.clear();
    widget.addTodo(todo);
  }

  _showDatePicker() {
    DateTime now = DateTime.now();
    Future<DateTime> selectedDate = showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    selectedDate.then((dueDate) {
      setState(() {
        dueDate = dueDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: min(400.0, MediaQuery.of(context).size.width - 20.0),
      padding: EdgeInsets.all(4.0),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              controller: titleInputController,
              decoration: InputDecoration(
                labelText: "Add Todo",
              ),
              onFieldSubmitted: (title) {
                _onSave();
              },
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _showDatePicker,
                ),
                ProjectDropdown(
                  onSelected: (selectedproject) {
                    setState(() {
                      project = selectedproject;
                    });
                  },
                ),
                Flexible(
                  child: Container(),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _onSave,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

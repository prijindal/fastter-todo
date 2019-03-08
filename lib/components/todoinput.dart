import 'dart:math';
import 'dart:io';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import '../models/todo.model.dart';
import '../models/project.model.dart';
import './projectdropdown.dart';
import '../fastter/fastter_action.dart';
import '../store/state.dart';
import '../helpers/todouihelpers.dart';

class TodoInput extends StatelessWidget {
  final void Function() onBackButton;
  TodoInput({Key key, this.onBackButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _TodoInput(
          addTodo: (todo) => store.dispatch(AddItem<Todo>(todo)),
          onBackButton: onBackButton,
        );
      },
    );
  }
}

class _TodoInput extends StatefulWidget {
  final void Function() onBackButton;
  final void Function(Todo todo) addTodo;

  _TodoInput({
    Key key,
    @required this.addTodo,
    this.onBackButton,
  }) : super(key: key);

  _TodoInputState createState() => _TodoInputState();
}

class _TodoInputState extends State<_TodoInput> with WidgetsBindingObserver {
  TextEditingController titleInputController = TextEditingController(text: "");
  FocusNode _titleFocusNode = FocusNode();
  bool _isPreventClose = false;
  DateTime dueDate;
  Project project;
  int subscribingId;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    this._focusKeyboard();
    if (Platform.isAndroid || Platform.isIOS) {
      subscribingId = KeyboardVisibilityNotification().addNewListener(
          onChange: (bool visible) {
        if (visible == false) {
          _unFocusKeyboard();
        } else {
          _focusKeyboard();
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (subscribingId != null) {
      KeyboardVisibilityNotification().removeListener(subscribingId);
    }
    super.dispose();
  }

  _focusKeyboard() async {
    FocusScope.of(context).requestFocus(_titleFocusNode);
  }

  _unFocusKeyboard() async {
    _titleFocusNode.unfocus();
    if (_isPreventClose) {
      return;
    }
    if (titleInputController.text.isNotEmpty) {
      setState(() {
        _isPreventClose = true;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Do you want to save before cancelling?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isPreventClose = false;
                    });
                    widget.onBackButton();
                  },
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _onSave();
                    setState(() {
                      _isPreventClose = false;
                    });
                    widget.onBackButton();
                  },
                ),
              ],
            ),
      );
    } else if (widget.onBackButton != null) {
      widget.onBackButton();
    }
  }

  _onSave() {
    if (dueDate == null) {
      dueDate = DateTime.now();
    }
    dueDate = new DateTime(dueDate.year, dueDate.month, dueDate.day, 0, 0, 0);
    Todo todo = Todo(
      title: titleInputController.text,
      dueDate: dueDate,
      project: project,
    );
    widget.addTodo(todo);
    if (mounted) {
      titleInputController.clear();
      _unFocusKeyboard();
    }
  }

  _showDatePicker() {
    setState(() {
      _isPreventClose = true;
    });
    Future<DateTime> selectedDate = todoSelectDate(context);
    selectedDate.then((dueDate) {
      setState(() {
        this.dueDate = dueDate;
        _isPreventClose = false;
        _focusKeyboard();
      });
    });
  }

  _onSelectProject(Project selectedproject) {
    setState(() {
      project = selectedproject;
      _isPreventClose = false;
      _focusKeyboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            color: Colors.white,
            width: min(480.0, MediaQuery.of(context).size.width - 20.0),
            padding: EdgeInsets.all(4.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleInputController,
                    focusNode: _titleFocusNode,
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
                        icon: Icon(
                          Icons.calendar_today,
                          color: dueDate == null ? null : Colors.redAccent,
                        ),
                        onPressed: _showDatePicker,
                      ),
                      ProjectDropdown(
                        selectedProject: project,
                        onSelected: _onSelectProject,
                        onOpening: () {
                          setState(() {
                            _isPreventClose = true;
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
          ),
        ),
      ),
    );
  }
}

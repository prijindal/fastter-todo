import 'dart:io';
import 'dart:math';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import '../fastter/fastter_action.dart';
import '../helpers/todouihelpers.dart';
import '../models/project.model.dart';
import '../models/todo.model.dart';
import '../store/state.dart';

import 'projectdropdown.dart';

class TodoInput extends StatelessWidget {
  const TodoInput({
    Key key,
    this.onBackButton,
    this.project,
  }) : super(key: key);

  final void Function() onBackButton;
  final Project project;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _TodoInput(
              addTodo: (todo) => store.dispatch(AddItem<Todo>(todo)),
              onBackButton: onBackButton,
              project: project,
            ),
      );
}

class _TodoInput extends StatefulWidget {
  const _TodoInput({
    @required this.addTodo,
    this.onBackButton,
    this.project,
    Key key,
  }) : super(key: key);

  final void Function() onBackButton;
  final void Function(Todo todo) addTodo;
  final Project project;

  @override
  _TodoInputState createState() => _TodoInputState();
}

class _TodoInputState extends State<_TodoInput> with WidgetsBindingObserver {
  final TextEditingController titleInputController =
      TextEditingController(text: '');
  final FocusNode _titleFocusNode = FocusNode();
  bool _isPreventClose = false;
  DateTime dueDate = DateTime.now();
  Project project;
  int subscribingId;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      project = widget.project;
    }
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isAndroid || Platform.isIOS) {
      subscribingId =
          KeyboardVisibilityNotification().addNewListener(onChange: (visible) {
        if (visible == false) {
          _unFocusKeyboard();
        } else {
          _focusKeyboard();
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusKeyboard();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (subscribingId != null) {
      KeyboardVisibilityNotification().removeListener(subscribingId);
    }
    super.dispose();
  }

  void _focusKeyboard() {
    FocusScope.of(context).requestFocus(_titleFocusNode);
  }

  void _unFocusKeyboard() {
    _titleFocusNode.unfocus();
    if (_isPreventClose) {
      return;
    }
    if (titleInputController.text.isNotEmpty) {
      setState(() {
        _isPreventClose = true;
      });
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Do you want to save before cancelling?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isPreventClose = false;
                    });
                    widget.onBackButton();
                  },
                ),
                FlatButton(
                  child: const Text('Yes'),
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

  void _onSave() {
    if (dueDate != null) {
      dueDate = DateTime(dueDate.year, dueDate.month, dueDate.day, 0, 0, 0);
    }
    final todo = Todo(
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

  void _showDatePicker() {
    setState(() {
      _isPreventClose = true;
    });
    todoSelectDate(context).then((date) {
      setState(() {
        if (date != null) {
          dueDate = date.dateTime;
        }
        _isPreventClose = false;
        _focusKeyboard();
      });
    });
  }

  void _onSelectProject(Project selectedproject) {
    setState(() {
      project = selectedproject;
      _isPreventClose = false;
      _focusKeyboard();
    });
  }

  @override
  Widget build(BuildContext context) => Material(
        elevation: 4,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Container(
              color: Colors.white,
              width: min(480, MediaQuery.of(context).size.width - 20.0),
              padding: const EdgeInsets.all(4),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleInputController,
                      focusNode: _titleFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Add a task',
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
                          icon: const Icon(Icons.add),
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

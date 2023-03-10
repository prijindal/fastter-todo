import 'dart:io';
import 'dart:math';
import 'dart:async';
import '../store/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../fastter/fastter_bloc.dart';
import '../models/project.model.dart';
import '../models/todo.model.dart';

import '../helpers/todouihelpers.dart';
import 'projectdropdown.dart';

class TodoInput extends StatelessWidget {
  const TodoInput({
    super.key,
    required this.onBackButton,
    this.project,
  });

  final void Function() onBackButton;
  final Project? project;

  @override
  Widget build(BuildContext context) => _TodoInput(
        addTodo: (todo) => fastterTodos.add(AddEvent<Todo>(todo)),
        onBackButton: onBackButton,
        project: project,
      );
}

class _TodoInput extends StatefulWidget {
  const _TodoInput({
    required this.addTodo,
    required this.onBackButton,
    this.project,
  });

  final void Function() onBackButton;
  final void Function(Todo todo) addTodo;
  final Project? project;

  @override
  _TodoInputState createState() => _TodoInputState();
}

class _TodoInputState extends State<_TodoInput> with WidgetsBindingObserver {
  final TextEditingController titleInputController =
      TextEditingController(text: '');
  final FocusNode _titleFocusNode = FocusNode();
  bool _isPreventClose = false;
  DateTime dueDate = DateTime.now();
  Project? project;
  StreamSubscription<bool>? subscribingId;

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      project = widget.project;
    }
    WidgetsBinding.instance.addObserver(this);
    var keyboardVisibilityController = KeyboardVisibilityController();
    subscribingId = keyboardVisibilityController.onChange.listen((visible) {
      if (visible == false) {
        _unFocusKeyboard();
      } else {
        _focusKeyboard();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusKeyboard();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscribingId?.cancel();
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
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isPreventClose = false;
                });
                widget.onBackButton();
              },
            ),
            TextButton(
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
          dueDate = date;
        }
        _isPreventClose = false;
        _focusKeyboard();
      });
    });
  }

  void _onSelectProject(Project? selectedproject) {
    setState(() {
      project = selectedproject;
      _isPreventClose = false;
      _focusKeyboard();
    });
  }

  double get _width => MediaQuery.of(context).orientation ==
          Orientation.portrait
      ? MediaQuery.of(context).size.width
      : MediaQuery.of(context).size.width - 304; // 304 is the _kWidth of drawer

  Widget _buildInput() => TextFormField(
        controller: titleInputController,
        focusNode: _titleFocusNode,
        decoration: InputDecoration(
          labelText: 'Add a task',
          contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
          suffix: IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed: () {
              titleInputController.clear();
              _unFocusKeyboard();
            },
          ),
        ),
        onFieldSubmitted: (title) {
          _onSave();
        },
      );

  Widget _buildButtons() => Flex(
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
            icon: const Icon(Icons.send),
            onPressed: _onSave,
          )
        ],
      );

  @override
  Widget build(BuildContext context) => Card(
        elevation: 8,
        child: Container(
          color: Colors.white,
          width: _width - 4.0,
          child: Center(
            child: Container(
              width: min(480, MediaQuery.of(context).size.width - 20.0),
              padding: const EdgeInsets.all(4),
              child: Form(
                child: Column(
                  children: [
                    _buildInput(),
                    _buildButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

import '../../helpers/logger.dart';
import '../../models/core.dart';
import '../../models/db_manager.dart';
import '../../models/local_db_state.dart';
import 'projectdropdown.dart';
import 'todo_select_date.dart';

class TodoInputBar extends StatefulWidget {
  const TodoInputBar({
    super.key,
    required this.onBackButton,
    this.initialProject,
    this.allowProjectSelection = false,
    this.parentTodo,
  });

  final void Function() onBackButton;
  final String? initialProject; // this will be a project id
  final String?
      parentTodo; // This will be the parent id which is added to the todo
  final bool allowProjectSelection;
  @override
  State<TodoInputBar> createState() => _TodoInputBarState();
}

class _TodoInputBarState extends State<TodoInputBar>
    with WidgetsBindingObserver {
  final TextEditingController titleInputController =
      TextEditingController(text: '');
  final FocusNode _titleFocusNode = FocusNode();
  DateTime? dueDate;
  bool _isPreventClose = false;
  StreamSubscription<bool>? subscribingId;
  ProjectData? project;

  @override
  void initState() {
    super.initState();
    _initialValues();
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    subscribingId?.cancel();
    super.dispose();
  }

  Future<void> _initialValues() async {
    if (widget.initialProject != null && widget.initialProject != "inbox") {
      final project = Provider.of<LocalDbState>(context, listen: false)
          .projects
          .where((f) => f.id == widget.initialProject)
          .firstOrNull;
      setState(() {
        this.project = project;
      });
    }
  }

  void _onSave() async {
    if (dueDate != null) {
      dueDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day, 0, 0, 0);
    }
    try {
      await Provider.of<DbManager>(context, listen: false)
          .database
          .managers
          .todo
          .create(
            (o) => o(
              title: titleInputController.text,
              dueDate: drift.Value(dueDate),
              project: drift.Value(project?.id),
              parent: drift.Value(widget.parentTodo),
            ),
          );
      if (mounted) {
        titleInputController.clear();
        await _unFocusKeyboard();
        if (mounted) {
          widget.onBackButton();
        }
      }
    } catch (e) {
      AppLogger.instance.e(e);
      rethrow;
    }
  }

  void _focusKeyboard() {
    if (!FocusScope.of(context).hasFocus) {
      FocusScope.of(context).requestFocus(_titleFocusNode);
    }
  }

  Future<void> _unFocusKeyboard() async {
    _titleFocusNode.unfocus();
    if (_isPreventClose) {
      return;
    }
    if (titleInputController.text.isNotEmpty) {
      setState(() {
        _isPreventClose = true;
      });
      await showDialog<void>(
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
    } else {
      widget.onBackButton();
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

  Widget _buildInput() => TextFormField(
        controller: titleInputController,
        focusNode: _titleFocusNode,
        autofocus: true,
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
            enabled: widget.allowProjectSelection,
            selectedProject: project,
            onSelected: (selectedProject) {
              setState(() {
                project = selectedProject;
              });
            },
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInput(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../helpers/logger.dart';
import '../../models/db_manager.dart';
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
  final _formKey = GlobalKey<FormBuilderState>();
  // final TextEditingController titleInputController =
  //     TextEditingController(text: '');
  final FocusNode _titleFocusNode = FocusNode();
  // DateTime? dueDate;
  bool _isPreventClose = false;
  StreamSubscription<bool>? subscribingId;
  // ProjectData? project;

  @override
  void initState() {
    super.initState();
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

  void _onSave() async {
    try {
      if (_formKey.currentState?.saveAndValidate() == false) {
        return;
      }
      final todo = _formKey.currentState!.value;
      await Provider.of<DbManager>(context, listen: false)
          .database
          .managers
          .todo
          .create(
            (o) => o(
              title: todo["title"] as String,
              project: drift.Value(todo["project"] as String?),
              dueDate: drift.Value(todo["dueDate"] as DateTime?),
              parent: drift.Value(widget.parentTodo),
            ),
          );
      _formKey.currentState!.reset();
      if (mounted) {
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
    final title = _formKey.currentState?.instantValue['title'] as String?;
    if (title != null && title != "") {
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

  Widget _buildInput() => FormBuilderTextField(
        name: "title",
        focusNode: _titleFocusNode,
        initialValue: "",
        autofocus: true,
        validator: FormBuilderValidators.required(),
        decoration: InputDecoration(
          labelText: 'Add a task',
          contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
          suffix: IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed: () {
              _formKey.currentState!.fields['title']?.didChange(null);
              _unFocusKeyboard();
            },
          ),
        ),
      );

  Widget _buildButtons() => Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FormBuilderField<DateTime?>(
            name: "dueDate",
            initialValue: null,
            builder: (FormFieldState<DateTime?> field) {
              return IconButton(
                icon: Icon(Icons.calendar_today),
                color: field.value == null ? null : Colors.redAccent,
                onPressed: () {
                  setState(() {
                    _isPreventClose = true;
                  });
                  todoSelectDate(context).then((date) {
                    setState(() {
                      if (date != null) {
                        field.didChange(date);
                      }
                      _isPreventClose = false;
                      _focusKeyboard();
                    });
                  });
                },
              );
            },
          ),
          FormBuilderProjectSelector(
            name: "project",
            initialValue: widget.initialProject,
            expanded: false,
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
      child: FormBuilder(
        key: _formKey,
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

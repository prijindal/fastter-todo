import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';

import '../../helpers/logger.dart';
import '../../models/core.dart';
import '../../models/db_manager.dart';
import '../../models/local_db_state.dart';
import '../todo/index.dart';
import 'pipeline_dialog.dart';
import 'priority_dialog.dart';
import 'projectdropdown.dart';
import 'tagselector.dart';
import 'todo_select_date.dart';

class TodoModifyBar extends StatelessWidget {
  const TodoModifyBar({
    super.key,
    required this.onBackButton,
    required this.todo,
    this.additionalFields = true,
  });

  final void Function() onBackButton;
  final TodoData todo;
  final bool additionalFields;

  @override
  Widget build(BuildContext context) => _TodoInputBar(
        onBackButton: onBackButton,
        initialProject: todo.project,
        initialPipeline: todo.pipeline,
        initialTitle: todo.title,
        initialPriority: todo.priority,
        initialTags: todo.tags,
        labelText: "Edit task: ${todo.title}",
        initialDueDate: todo.dueDate,
        parentTodo: todo.parent,
        leadingButtons: [],
        trailingButtons: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.of(context).maybePop();
              // ignore: use_build_context_synchronously
              TodoScreen.openPage(context, todo);
            },
            tooltip: 'Edit Todo',
          ),
        ],
        additionalFields: additionalFields,
        onSave: ({
          required String title,
          String? project,
          DateTime? dueDate,
          String? pipeline,
          int? priority,
          List<String>? tags,
        }) async {
          await GetIt.I<DbManager>()
              .database
              .managers
              .todo
              .filter((a) => a.id.equals(todo.id))
              .update(
                (o) => o(
                  title: drift.Value(title),
                  project: drift.Value(project ?? todo.project),
                  dueDate: drift.Value(dueDate ?? todo.dueDate),
                  pipeline: drift.Value(pipeline ?? todo.pipeline),
                  priority: drift.Value(priority ?? todo.priority),
                  tags: drift.Value(tags ?? todo.tags),
                ),
              );
        },
      );
}

class TodoInputBar extends StatelessWidget {
  const TodoInputBar({
    super.key,
    required this.onBackButton,
    this.initialProject,
    this.initialPipeline,
    this.parentTodo,
    this.additionalFields = true,
  });

  final void Function() onBackButton;
  final bool additionalFields;
  final String? initialProject; // this will be a project id
  final String? initialPipeline; // this will be a pipeline id
  final String?
      parentTodo; // This will be the parent id which is added to the todo

  @override
  Widget build(BuildContext context) => _TodoInputBar(
        onBackButton: onBackButton,
        initialProject: initialProject,
        initialPipeline: initialPipeline,
        parentTodo: parentTodo,
        labelText: "Add a task",
        additionalFields: additionalFields,
        onSave: ({
          required String title,
          String? project,
          DateTime? dueDate,
          required String pipeline,
          int priority = 1,
          List<String> tags = const [],
        }) async {
          await GetIt.I<DbManager>().database.managers.todo.create(
                (o) => o(
                  title: title,
                  project: drift.Value(project),
                  dueDate: drift.Value(dueDate),
                  parent: drift.Value(parentTodo),
                  pipeline: drift.Value(pipeline),
                  priority: drift.Value(priority),
                  tags: drift.Value(tags),
                ),
              );
        },
      );
}

class _TodoInputBar extends StatefulWidget {
  const _TodoInputBar({
    required this.onBackButton,
    required this.labelText,
    this.leadingButtons = const [],
    this.trailingButtons = const [],
    this.initialProject,
    this.initialPipeline,
    this.parentTodo,
    required this.onSave,
    this.initialTitle = "",
    this.initialDueDate,
    this.initialPriority,
    this.initialTags,
    this.additionalFields = true,
  });

  final void Function() onBackButton;
  final String labelText;
  final bool additionalFields;
  final List<Widget> leadingButtons;
  final List<Widget> trailingButtons;
  final String? initialProject; // this will be a project id
  final String? initialPipeline; // this will be a pipeline id
  final String initialTitle;
  final DateTime? initialDueDate;
  final int? initialPriority;
  final List<String>? initialTags;
  final String?
      parentTodo; // This will be the parent id which is added to the todo
  final Future<void> Function({
    required String title,
    String? project,
    DateTime? dueDate,
    required String pipeline,
    int priority,
    List<String> tags,
  }) onSave;
  @override
  State<_TodoInputBar> createState() => _TodoInputBarState();
}

class _TodoInputBarState extends State<_TodoInputBar>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _titleFocusNode = FocusNode();
  bool _isPreventClose = false;
  StreamSubscription<bool>? subscribingId;

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
      final project = todo["project"] as String?;
      final pipelines = GetIt.I<LocalDbState>().getProjectPipelines(project);
      final selectedPipeline = todo["pipeline"] as String?;
      final pipeline =
          selectedPipeline != null && pipelines.contains(selectedPipeline)
              ? selectedPipeline
              : pipelines.first;
      await widget.onSave(
        title: todo["title"] as String,
        project: project,
        dueDate: todo["dueDate"] as DateTime?,
        pipeline: pipeline,
        priority: todo["priority"] as int? ?? 1,
        tags: todo["tags"] as List<String>? ?? [],
      );
      _formKey.currentState!.reset();
      if (mounted) {
        await _unFocusKeyboard(
          checkTitle: false,
        );
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

  Future<void> _unFocusKeyboard({bool checkTitle = true}) async {
    _titleFocusNode.unfocus();
    if (_isPreventClose) {
      return;
    }
    final title = _formKey.currentState?.instantValue['title'] as String?;
    if (title != null && title != widget.initialTitle && checkTitle) {
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

  Widget _buildTitleInputSuffix() {
    if (widget.additionalFields == false) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _formKey.currentState!.fields['title']?.didChange(null);
              _unFocusKeyboard();
            },
          ),
          IconButton(
            key: const Key("TodoInputBarSendButton"),
            icon: const Icon(Icons.send),
            onPressed: _onSave,
          ),
        ],
      );
    }
    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        _formKey.currentState!.fields['title']?.didChange(null);
        _unFocusKeyboard();
      },
    );
  }

  Widget _buildInput() => FormBuilderTextField(
        name: "title",
        key: Key("TodoInputBarTitleForm"),
        focusNode: _titleFocusNode,
        initialValue: widget.initialTitle,
        autofocus: true,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.minLength(3),
          FormBuilderValidators.maxLength(100),
        ]),
        decoration: InputDecoration(
          labelText: widget.labelText,
          contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
          suffix: _buildTitleInputSuffix(),
        ),
        onSubmitted: (_) {
          _onSave();
        },
      );

  Widget _buildPipelineButton() {
    final pipelines = GetIt.I<LocalDbState>().getProjectPipelines(
        (_formKey.currentState?.instantValue['project'] ??
            widget.initialProject) as String?);
    return FormBuilderField<String>(
      name: "pipeline",
      initialValue: widget.initialPipeline ?? pipelines.first,
      builder: (FormFieldState<String> field) {
        final pipelines = GetIt.I<LocalDbState>().getProjectPipelines(
            _formKey.currentState?.instantValue['project'] as String?);
        return TextButton(
          child: Text(field.value ?? pipelines.first),
          onPressed: () {
            setState(() {
              _isPreventClose = true;
            });
            showPipelineDialog(context, pipelines).then((date) {
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
    );
  }

  Widget _buildPriorityButton() {
    return FormBuilderField<int>(
      name: "priority",
      initialValue: widget.initialPriority ?? 1,
      builder: (FormFieldState<int> field) {
        return IconButton(
          icon: Text(
            field.value.toString(),
          ),
          color: priorityColors[(field.value ?? 1) - 1],
          onPressed: () {
            setState(() {
              _isPreventClose = true;
            });
            showPriorityDialog(context).then((date) {
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
    );
  }

  Widget _buildButtons() => Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...widget.leadingButtons,
          FormBuilderField<DateTime?>(
            name: "dueDate",
            initialValue: widget.initialDueDate,
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
            onChanged: (_) {
              setState(() {
                _isPreventClose = false;
                _focusKeyboard();
              });
            },
          ),
          _buildPipelineButton(),
          _buildPriorityButton(),
          FormBuilderTagSelector(
            name: "tags",
            initialValue: widget.initialTags ?? [],
            expanded: false,
            onOpening: () {
              setState(() {
                _isPreventClose = true;
              });
            },
            onChanged: (_) {
              setState(() {
                _isPreventClose = false;
                _focusKeyboard();
              });
            },
          ),
          ...widget.trailingButtons,
          Flexible(
            child: Container(),
          ),
          IconButton(
            key: const Key("TodoInputBarSendButton"),
            icon: const Icon(Icons.send),
            onPressed: _onSave,
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    if (widget.additionalFields == false) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
        child: FormBuilder(
          key: _formKey,
          child: _buildInput(),
        ),
      );
    }
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

import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:watch_it/watch_it.dart';

import '../../db/db_crud_operations.dart';
import '../../helpers/breakpoints.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';
import '../todocomments/todo_comment_item.dart';
import '../todoreminders/index.dart';
import '../todos/priority_dialog.dart';
import '../todos/projectdropdown.dart';
import '../todos/tagselector.dart';
import '../todos/todo_item.dart';
import '../todos/todo_item_elements.dart';
import '../todos/todoinputbar.dart';

@RoutePage()
class TodoScreen extends StatelessWidget {
  const TodoScreen({
    super.key,
    @PathParam() required this.todoId,
  });

  final String todoId;

  static Future<void> openBottomSheet(
      BuildContext context, TodoData todo) async {
    // TODO: Improve this, rather than a full page, make something like todoinputbar
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: TodoModifyBar(
          todo: todo,
          onBackButton: () {
            if (context.mounted) {
              AutoRouter.of(context).maybePop();
            }
          },
        ),
      ),
    );
  }

  static Future<void> openPage(BuildContext context, TodoData todo) async {
    if (isDesktop) {
      final mediaQuery = MediaQuery.sizeOf(context);
      await showDialog<void>(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              width: min(600, mediaQuery.width),
              height: min(800, mediaQuery.height),
              child: TodosScreenScaffold(
                todo: todo,
                elements: elements(todo),
              ),
            ),
          );
        },
      );
    } else {
      await AutoRouter.of(context).pushPath("/todo/${todo.id}");
    }
  }

  static List<TodoItemElements> elements(TodoData todo) {
    if (todo.parent == null) {
      return allTodoItemElements;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final todo =
        GetIt.I<LocalDbState>().todos.where((a) => a.id == todoId).first;
    return TodosScreenScaffold(
      todo: todo,
      elements: elements(todo),
    );
  }
}

class TodosScreenScaffold extends StatelessWidget {
  const TodosScreenScaffold({
    super.key,
    required this.todo,
    required this.elements,
  });

  final TodoData todo;
  final List<TodoItemElements> elements;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await GetIt.I<DbCrudOperations>().deleteTodosByIds([todo.id]);
              // ignore: use_build_context_synchronously
              await AutoRouter.of(context).maybePop();
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: TodoEditBody(
        todo: todo,
        onSave: () {
          AutoRouter.of(context).maybePop();
        },
        elements: elements,
      ),
    );
  }
}

class TodoEditBody extends StatefulWidget {
  const TodoEditBody({
    super.key,
    required this.todo,
    this.onSave,
    required this.elements,
  });

  final TodoData todo;
  final VoidCallback? onSave;
  final List<TodoItemElements> elements;

  @override
  State<TodoEditBody> createState() => _TodoEditBodyState();
}

class _TodoEditBodyState extends State<TodoEditBody> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isEdited = false;

  void _save() async {
    if (_formKey.currentState?.saveAndValidate() == true) {
      final todo = _formKey.currentState!.value;
      await GetIt.I<DbCrudOperations>().todo.update(
        [widget.todo.id],
        TodoCompanion(
          title: drift.Value(todo["title"] as String),
          project: drift.Value(todo["project"] as String?),
          priority: drift.Value(todo["priority"] as int),
          dueDate: drift.Value(todo["dueDate"] as DateTime?),
          tags: drift.Value(todo["tags"] as List<String>),
          pipeline: drift.Value(todo["pipeline"] as String),
          completed: drift.Value(todo["completed"] as bool),
        ),
      );
      widget.onSave?.call();
    }
  }

  void _markEdited(dynamic d) {
    setState(() {
      _isEdited = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final possiblePipelines =
        GetIt.I<LocalDbState>().getProjectPipelines(widget.todo.project);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FormBuilder(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            FormBuilderTextField(
              name: "title",
              initialValue: widget.todo.title,
              onChanged: _markEdited,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(3),
                FormBuilderValidators.maxLength(100),
              ]),
            ),
            FormBuilderCheckbox(
              name: "completed",
              title: Text('Completed'),
              initialValue: widget.todo.completed,
              onChanged: _markEdited,
            ),
            if (widget.elements.contains(TodoItemElements.pipeline))
              FormBuilderDropdown<String>(
                enabled: widget.elements.contains(TodoItemElements.pipeline),
                name: "pipeline",
                initialValue: possiblePipelines.contains(widget.todo.pipeline)
                    ? widget.todo.pipeline
                    : possiblePipelines.first,
                decoration: InputDecoration(
                  labelText: 'Pipeline',
                ),
                onChanged: _markEdited,
                items: possiblePipelines
                    .map((a) => DropdownMenuItem<String>(
                          value: a,
                          child: Text(a),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 10),
            if (widget.elements.contains(TodoItemElements.project))
              FormBuilderProjectSelector(
                name: "project",
                initialValue: widget.todo.project,
                expanded: true,
                onChanged: _markEdited,
                decoration: InputDecoration(
                  labelText: 'Project',
                ),
              ),
            const SizedBox(height: 10),
            if (widget.elements.contains(TodoItemElements.dueDate))
              FormBuilderDateTimePicker(
                name: "dueDate",
                inputType: InputType.date,
                initialValue: widget.todo.dueDate,
                onChanged: _markEdited,
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState!.fields['dueDate']?.didChange(null);
                    },
                  ),
                ),
              ),
            const SizedBox(height: 10),
            if (widget.elements.contains(TodoItemElements.priority))
              FormBuilderDropdown<int>(
                name: "priority",
                initialValue: widget.todo.priority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                ),
                onChanged: _markEdited,
                items: priorityColors.map(
                  (p) {
                    final value = priorityColors.indexOf(p) + 1;
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Wrap(
                        spacing: 8.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: p,
                            ),
                          ),
                          Text(
                            'Priority $value',
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            const SizedBox(height: 10),
            if (widget.elements.contains(TodoItemElements.tags))
              FormBuilderTagSelector(
                name: "tags",
                initialValue: widget.todo.tags,
                expanded: true,
                onChanged: _markEdited,
                decoration: InputDecoration(
                  labelText: 'Tags',
                ),
              ),
            const SizedBox(height: 10),
            if (widget.elements.contains(TodoItemElements.comments))
              _ExpansionTodoComment(
                todo: widget.todo,
              ),
            const SizedBox(height: 10),
            if (widget.elements.contains(TodoItemElements.reminders))
              _ExpansionTodoReminder(
                todo: widget.todo,
              ),
            const SizedBox(height: 10),
            if (widget.elements.contains(TodoItemElements.children))
              _ExpansionTodoChildren(todo: widget.todo),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isEdited == false
                  ? null
                  : () {
                      _save();
                    },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}

class _ExpansionTodoComment extends WatchingWidget {
  const _ExpansionTodoComment({required this.todo});
  final TodoData todo;

  @override
  Widget build(BuildContext context) {
    final comments = watchPropertyValue((LocalDbState state) =>
        state.comments.where((a) => a.todo == todo.id).toList());
    return ExpansionTile(
      leading: IconButton(
        onPressed: () =>
            AutoRouter.of(context).pushPath("/todocomments/${todo.id}"),
        icon: const Icon(Icons.list),
      ),
      initiallyExpanded: true,
      enabled: comments.isNotEmpty,
      title: Text("${comments.length} Comments"),
      children: comments
          .map((comment) => TodoCommentItem(
                todoComment: comment,
                dense: true,
                dismissible: false,
              ))
          .toList(),
    );
  }
}

class _ExpansionTodoReminder extends WatchingWidget {
  const _ExpansionTodoReminder({required this.todo});
  final TodoData todo;

  @override
  Widget build(BuildContext context) {
    final reminders = watchPropertyValue(
        (LocalDbState state) => state.getTodoReminders(todo.id, true));
    return ExpansionTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () =>
                AutoRouter.of(context).pushPath("/todoreminders/${todo.id}"),
            icon: const Icon(Icons.list),
          ),
          IconButton(
            onPressed: () => newReminder(context, todo.id),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      initiallyExpanded: true,
      enabled: reminders.isNotEmpty,
      title: Text("${reminders.length} Reminders"),
      children: reminders
          .map((reminder) => TodoReminderTile(
                reminder: reminder,
                dense: true,
              ))
          .toList(),
    );
  }
}

class _ExpansionTodoChildren extends WatchingStatefulWidget {
  const _ExpansionTodoChildren({
    required this.todo,
  });

  final TodoData todo;

  @override
  State<_ExpansionTodoChildren> createState() => _ExpansionTodoChildrenState();
}

class _ExpansionTodoChildrenState extends State<_ExpansionTodoChildren> {
  bool _adding = false;

  @override
  Widget build(BuildContext context) {
    final children = watchPropertyValue((LocalDbState state) =>
        state.todos.where((a) => a.parent == widget.todo.id).toList());
    return ExpansionTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => AutoRouter.of(context)
                .pushPath("/todochildren/${widget.todo.id}"),
            icon: const Icon(Icons.list),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _adding = true;
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      initiallyExpanded: true,
      enabled: children.isNotEmpty,
      title: Text("${children.length} Children"),
      children: [
        ...children.map((todo) => TodoItem(
              todo: todo,
              dense: true,
              tapBehaviour: TodoItemTapBehaviour.openTodoPage,
              dismissible: false,
              elements: [],
            )),
        if (_adding)
          TodoInputBar(
            parentTodo: widget.todo.id,
            initialProject: widget.todo.project,
            additionalFields: false,
            initialPipeline: widget.todo.pipeline,
            onBackButton: () {
              setState(() {
                _adding = false;
              });
            },
          ),
      ],
    );
  }
}

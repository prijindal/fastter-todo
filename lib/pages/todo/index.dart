import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../models/core.dart';
import '../../models/db_manager.dart';
import '../../models/local_db_state.dart';
import '../todos/priority_dialog.dart';
import '../todos/projectdropdown.dart';
import '../todos/tagselector.dart';

@RoutePage()
class TodoScreen extends StatelessWidget {
  const TodoScreen({
    super.key,
    @PathParam() required this.todoId,
  });

  final String todoId;

  @override
  Widget build(BuildContext context) => Selector<LocalDbState, TodoData>(
        selector: (_, state) => state.todos.where((a) => a.id == todoId).first,
        builder: (context, todo, _) => _TodoScreen(
          todo: todo,
        ),
      );
}

class _TodoScreen extends StatelessWidget {
  const _TodoScreen({
    required this.todo,
  });

  final TodoData todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Provider.of<DbManager>(context, listen: false)
                  .deleteTodosByIds([todo.id]);
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
      ),
    );
  }
}

class TodoEditBody extends StatefulWidget {
  const TodoEditBody({
    super.key,
    required this.todo,
    this.onSave,
  });

  final TodoData todo;
  final VoidCallback? onSave;

  @override
  State<TodoEditBody> createState() => _TodoEditBodyState();
}

class _TodoEditBodyState extends State<TodoEditBody> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isEdited = false;

  void _save() async {
    if (_formKey.currentState?.saveAndValidate() == true) {
      final todo = _formKey.currentState!.value;
      await Provider.of<DbManager>(context, listen: false)
          .database
          .managers
          .todo
          .filter((a) => a.id.equals(widget.todo.id))
          .update(
            (o) => o(
              title: drift.Value(todo["title"] as String),
              project: drift.Value(todo["project"] as String?),
              priority: drift.Value(todo["priority"] as int),
              dueDate: drift.Value(todo["dueDate"] as DateTime?),
              tags: drift.Value(todo["tags"] as List<String>),
              completed: drift.Value(todo["completed"] as bool),
            ),
          );
      widget.onSave?.call();
    }
  }

  void _markEdited(dynamic) {
    setState(() {
      _isEdited = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: <Widget>[
            FormBuilderCheckbox(
              name: "completed",
              title: Text('Completed'),
              initialValue: widget.todo.completed,
              onChanged: _markEdited,
            ),
            FormBuilderTextField(
              name: "title",
              initialValue: widget.todo.title,
              onChanged: _markEdited,
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 10),
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
            Selector<LocalDbState, int>(
              selector: (_, state) =>
                  state.comments.where((a) => a.todo == widget.todo.id).length,
              builder: (context, comments, _) {
                return ListTile(
                  title: Text("$comments Comments"),
                  onTap: () => AutoRouter.of(context)
                      .pushNamed("/todocomments/${widget.todo.id}"),
                );
              },
            ),
            const SizedBox(height: 10),
            Selector<LocalDbState, int>(
              selector: (_, state) =>
                  state.getTodoReminders(widget.todo.id, true).length,
              builder: (context, reminders, _) {
                return ListTile(
                  title: Text("$reminders Reminders"),
                  onTap: () => AutoRouter.of(context)
                      .pushNamed("/todoreminders/${widget.todo.id}"),
                );
              },
            ),
            const SizedBox(height: 10),
            Selector<LocalDbState, int>(
              selector: (_, state) =>
                  state.todos.where((a) => a.parent == widget.todo.id).length,
              builder: (context, children, _) {
                return ListTile(
                  title: Text("$children Children"),
                  onTap: () => AutoRouter.of(context)
                      .pushNamed("/todochildren/${widget.todo.id}"),
                );
              },
            ),
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

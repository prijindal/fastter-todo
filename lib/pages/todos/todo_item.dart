import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../helpers/date_fomatters.dart';
import '../../models/core.dart';
import '../../models/drift.dart';
import '../../models/local_state.dart';
import 'confirmation_dialog.dart';
import 'tagslist.dart';
import 'todo_select_date.dart';
import 'todoitemtoggle.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.todo,
  });

  final TodoData todo;

  void _selectDate(BuildContext context) {
    todoSelectDate(context, todo.dueDate).then((dueDate) async {
      if (dueDate != null) {
        await MyDatabase.instance.managers.todo
            .filter((tbl) => tbl.id.equals(todo.id))
            .update((o) => o(dueDate: drift.Value(dueDate)));
      }
    });
  }

  Future<bool?> _confirmDelete(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (context) => ConfirmationDialog(),
      );

  void _deleteTodo() async {
    await MyDatabase.instance.managers.todo
        .filter((tbl) => tbl.id.equals(todo.id))
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _selectDate(context);
          return false;
        } else if (direction == DismissDirection.endToStart) {
          return _confirmDelete(context);
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _deleteTodo();
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${todo.title} deleted')));
        }
      },
      background: Flex(
        direction: Axis.horizontal,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Icon(Icons.calendar_today),
          ),
          Flexible(
            child: Container(),
          ),
        ],
      ),
      secondaryBackground: Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            child: Container(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Icon(Icons.delete),
          ),
        ],
      ),
      child: Selector<LocalStateNotifier, bool>(
        selector: (context, localState) =>
            localState.selectedTodoIds.contains(todo.id),
        builder: (context, selected, _) => ListTile(
          selected: selected,
          onTap: () {
            final localStateNotifier =
                Provider.of<LocalStateNotifier>(context, listen: false);
            if (selected) {
              localStateNotifier.setSelectedTodoIds(localStateNotifier
                  .selectedTodoIds
                  .where((a) => a != todo.id)
                  .toList());
            } else {
              localStateNotifier.setSelectedTodoIds(
                  localStateNotifier.selectedTodoIds..add(todo.id));
            }
          },
          leading: TodoItemToggle(
            todo: todo,
            toggleCompleted: (bool newValue) async {
              await MyDatabase.instance.managers.todo
                  .filter((tbl) => tbl.id.equals(todo.id))
                  .update((o) => o(completed: drift.Value(newValue)));
            },
          ),
          title: Text(todo.title),
          subtitle: TodoItemSubtitle(
            todo: todo,
          ),
        ),
      ),
    );
  }
}

TextStyle _subtitleTextStyle(ThemeData theme) {
  final style = theme.textTheme.bodyMedium ?? TextStyle();
  final color = theme.disabledColor;
  return style.copyWith(color: color);
}

class TodoItemSubtitle extends StatelessWidget {
  const TodoItemSubtitle({super.key, required this.todo});

  final TodoData todo;

  Widget _buildDueDate(BuildContext context) => DefaultTextStyle(
        style: _subtitleTextStyle(Theme.of(context)),
        child: Flexible(
          flex: 0,
          child: Text(dueDateFormatter(todo.dueDate)),
        ),
      );
  Widget _buildSubtitleFirstRow(BuildContext context) {
    final children = <Widget>[];
    final reminders = 0; // TODO
    final comments = 0; // TODO
    if (todo.dueDate != null) {
      children.add(_buildDueDate(context));
    }
    if (reminders > 0) {
      children.add(
        Container(
          margin: const EdgeInsets.only(left: 4),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.alarm,
                size: 20,
              ),
              Text(reminders.toString()),
            ],
          ),
        ),
      );
    }
    if (comments > 0) {
      children.add(
        Container(
          margin: const EdgeInsets.only(left: 4),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.comment,
                size: 20,
              ),
              Text(comments.toString()),
            ],
          ),
        ),
      );
    }
    children.add(Flexible(
      child: Container(),
    ));
    children.add(SubtitleProject(
      todo: todo,
    ));
    if (children.isEmpty) {
      return Container();
    }
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstRow = _buildSubtitleFirstRow(context);
    if (todo.tags.isEmpty) {
      return firstRow;
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: firstRow,
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 100,
            ),
            child: TagsList(
              tags: todo.tags,
            ),
          )
        ],
      );
    }
  }
}

class SubtitleProject extends StatelessWidget {
  const SubtitleProject({
    super.key,
    required this.todo,
  });

  final TodoData todo;

  Flex _buildContainer(ProjectData? project) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 40),
          child: Text(
            // TODO: Replace with actual title of project
            project?.title ?? "Inbox",
          ),
        ),
        Icon(
          Icons.group_work,
          color: project == null ? null : HexColor(project.color),
          size: 16,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: _subtitleTextStyle(Theme.of(context)),
      child: Flexible(
        flex: 1,
        child: todo.project == null
            ? _buildContainer(null)
            : StreamBuilder<ProjectData>(
                stream: MyDatabase.instance.managers.project
                    .filter((f) => f.id.equals(todo.project))
                    .watchSingle(),
                builder: (context, projectSnapshot) {
                  if (!projectSnapshot.hasData) {
                    return Container();
                  }
                  return _buildContainer(projectSnapshot.data);
                },
              ),
      ),
    );
  }
}

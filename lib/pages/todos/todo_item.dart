import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../helpers/date_fomatters.dart';
import '../../models/core.dart';
import '../../models/db_manager.dart';
import '../../models/local_db_state.dart';
import '../../models/local_state.dart';
import 'confirmation_dialog.dart';
import 'tagslist.dart';
import 'todo_select_date.dart';
import 'todoitemtoggle.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.todo,
    this.allowSelection = true,
    this.dense = false,
  });

  final TodoData todo;
  final bool allowSelection;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    if (!allowSelection) {
      return _TodoItem(
        todo: todo,
        selected: false,
        dense: true,
        onTap: () => AutoRouter.of(context).pushNamed("/todo/${todo.id}"),
      );
    }
    return Selector<LocalStateNotifier, bool>(
      selector: (context, localState) =>
          localState.selectedTodoIds.contains(todo.id),
      builder: (context, selected, _) => _TodoItem(
        todo: todo,
        selected: selected,
        onTap: () {
          final localStateNotifier =
              Provider.of<LocalStateNotifier>(context, listen: false);
          localStateNotifier.toggleSelectedId(todo.id);
        },
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  const _TodoItem({
    required this.todo,
    required this.selected,
    this.dense = false,
    this.onTap,
  });

  final TodoData todo;
  final bool selected;
  final bool dense;
  final void Function()? onTap;

  void _selectDate(BuildContext context) {
    todoSelectDate(context, todo.dueDate).then((dueDate) async {
      if (dueDate != null && context.mounted) {
        await Provider.of<DbManager>(context, listen: false)
            .database
            .managers
            .todo
            .filter((tbl) => tbl.id.equals(todo.id))
            .update((o) => o(dueDate: drift.Value(dueDate)));
      }
    });
  }

  Future<bool?> _confirmDelete(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (context) => ConfirmationDialog(),
      );

  void _deleteTodo(BuildContext context) async {
    await Provider.of<DbManager>(context, listen: false)
        .deleteTodosByIds([todo.id]);
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
          _deleteTodo(context);
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
      child: ListTile(
        dense: dense,
        selected: selected,
        onTap: onTap,
        leading: TodoItemToggle(
          todo: todo,
          toggleCompleted: (bool newValue) async {
            await Provider.of<DbManager>(context, listen: false)
                .database
                .managers
                .todo
                .filter((tbl) => tbl.id.equals(todo.id))
                .update((o) => o(completed: drift.Value(newValue)));
          },
        ),
        title: Text(
          todo.title,
        ),
        subtitle: TodoItemSubtitle(
          todo: todo,
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
  Widget _buildSubtitleFirstRow(
      BuildContext context, int comments, int reminders, int childTodos) {
    var children = <Widget>[];
    var mainAxisAlignment = MainAxisAlignment.spaceBetween;
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
    if (childTodos > 0) {
      children.add(
        Container(
          margin: const EdgeInsets.only(left: 4),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.format_strikethrough,
                size: 20,
              ),
              Text(childTodos.toString()),
            ],
          ),
        ),
      );
    }
    if (children.isNotEmpty) {
      // If childrens are not empty, we will take all of them and wrap it inside a row
      final subRow = Row(
        children: children,
      );
      children = [subRow];
    } else {
      // If children are empty, since there is only one element, which is going to be project, we display it at end
      mainAxisAlignment = MainAxisAlignment.end;
    }
    children.add(SubtitleProject(
      todo: todo,
    ));
    if (children.isEmpty) {
      return Container();
    }
    return Row(
      // direction: Axis.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstRow =
        Selector<LocalDbState, ({int reminders, int comments, int childTodos})>(
      selector: (_, state) => (
        reminders: state.getTodoReminders(todo.id, true).length,
        comments: state.comments.where((f) => f.todo == todo.id).length,
        childTodos: state.todos.where((a) => a.parent == todo.id).length,
      ),
      builder: (context, counts, _) => _buildSubtitleFirstRow(
        context,
        counts.comments,
        counts.reminders,
        counts.childTodos,
      ),
    );
    final tags = Provider.of<LocalDbState>(context).getTodoTag(todo.id);
    if (tags.isEmpty) {
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
              tags: tags,
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
      mainAxisSize: MainAxisSize.min,
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 40),
          child: Text(
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
            : Selector<LocalDbState, ProjectData?>(
                selector: (_, state) => state.projects
                    .where((f) => f.id == todo.project)
                    .firstOrNull,
                builder: (context, project, _) {
                  return _buildContainer(project);
                },
              ),
      ),
    );
  }
}

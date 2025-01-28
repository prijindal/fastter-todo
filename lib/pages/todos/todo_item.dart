import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../helpers/date_fomatters.dart';
import '../../models/core.dart';
import '../../models/db_manager.dart';
import '../../models/local_db_state.dart';
import '../../models/local_state.dart';
import '../todo/index.dart';
import 'confirmation_dialog.dart';
import 'tagslist.dart';
import 'todo_item_elements.dart';
import 'todo_select_date.dart';
import 'todoitemtoggle.dart';

enum TodoItemTapBehaviour {
  openTodoPage,
  openTodoBottomSheet,
  toggleSelection,
  nothing;
}

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.todo,
    required this.tapBehaviour,
    this.longPressBehaviour = TodoItemTapBehaviour.nothing,
    this.dense = false,
    this.dismissible = true,
    this.elements = allTodoItemElements,
  });

  final TodoData todo;
  final bool dense;
  final bool dismissible;
  final TodoItemTapBehaviour tapBehaviour;
  final TodoItemTapBehaviour longPressBehaviour;
  final List<TodoItemElements> elements;

  static VoidCallback? action(
      TodoItemTapBehaviour behaviour, BuildContext context, TodoData todo) {
    switch (behaviour) {
      case TodoItemTapBehaviour.openTodoPage:
        return () => TodoScreen.openPage(context, todo);
      case TodoItemTapBehaviour.openTodoBottomSheet:
        return () => TodoScreen.openBottomSheet(context, todo);
      case TodoItemTapBehaviour.toggleSelection:
        return () {
          final localStateNotifier =
              Provider.of<LocalStateNotifier>(context, listen: false);
          localStateNotifier.toggleSelectedId(todo.id);
        };
      case TodoItemTapBehaviour.nothing:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tapBehaviour == TodoItemTapBehaviour.toggleSelection ||
        longPressBehaviour == TodoItemTapBehaviour.toggleSelection) {
      return Selector<LocalStateNotifier, bool>(
        selector: (context, localState) =>
            localState.selectedTodoIds.contains(todo.id),
        builder: (context, selected, _) => _TodoItem(
          todo: todo,
          selected: selected,
          dismissible: dismissible,
          dense: dense,
          elements: elements,
          onTap: action(tapBehaviour, context, todo),
          onLongPress: action(longPressBehaviour, context, todo),
        ),
      );
    }
    return _TodoItem(
      todo: todo,
      selected: false,
      dense: dense,
      dismissible: dismissible,
      elements: elements,
      onTap: action(tapBehaviour, context, todo),
      onLongPress: action(longPressBehaviour, context, todo),
    );
  }
}

class _TodoItem extends StatelessWidget {
  const _TodoItem({
    required this.todo,
    required this.selected,
    this.dense = false,
    this.dismissible = true,
    this.onTap,
    this.onLongPress,
    required this.elements,
  });

  final TodoData todo;
  final bool selected;
  final bool dense;
  final bool dismissible;
  final List<TodoItemElements> elements;
  final void Function()? onTap;
  final void Function()? onLongPress;

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

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      dense: dense,
      selected: selected,
      onTap: onTap,
      onLongPress: onLongPress,
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
      isThreeLine: elements.isNotEmpty,
      title: Text(
        todo.title,
      ),
      subtitle: elements.isEmpty
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _TodoItemFirstRow(
                  todo: todo,
                  project: elements.contains(TodoItemElements.project),
                  pipeline: elements.contains(TodoItemElements.project),
                ),
                _TodoItemSecondRow(
                  todo: todo,
                  showDueDate: elements.contains(TodoItemElements.dueDate),
                  showReminders: elements.contains(TodoItemElements.reminders),
                  showComments: elements.contains(TodoItemElements.comments),
                  showChildren: elements.contains(TodoItemElements.children),
                ),
                if (elements.contains(TodoItemElements.tags))
                  _TodoItemThirdRow(
                    todo: todo,
                  ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (dismissible == false) {
      return _buildListTile(context);
    }
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
      child: _buildListTile(context),
    );
  }
}

// First row displays pipeline and project
class _TodoItemFirstRow extends StatelessWidget {
  const _TodoItemFirstRow({
    required this.todo,
    required this.pipeline,
    required this.project,
  });

  final TodoData todo;
  final bool pipeline;
  final bool project;

  @override
  Widget build(BuildContext context) {
    if (![pipeline, project].contains(true)) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (pipeline) Text(todo.pipeline),
        if (project) _SubtitleProject(todo: todo),
      ],
    );
  }
}

// Second row displays due date, reminders, comments, and child todos
class _TodoItemSecondRow extends StatelessWidget {
  const _TodoItemSecondRow({
    required this.todo,
    required this.showDueDate,
    required this.showReminders,
    required this.showComments,
    required this.showChildren,
  });

  final TodoData todo;
  final bool showDueDate;
  final bool showReminders;
  final bool showComments;
  final bool showChildren;

  Widget _buildSecondRow(
      BuildContext context, int comments, int reminders, int childTodos) {
    var children = <Widget>[];
    final iconSize =
        (ListTileTheme.of(context).subtitleTextStyle?.fontSize ?? 12) + 2;
    if (todo.dueDate != null && showDueDate) {
      children.add(
        Container(
          margin: const EdgeInsets.only(left: 4),
          child: Text(
            dueDateFormatter(
              todo.dueDate,
            ),
          ),
        ),
      );
    }
    if (reminders > 0 && showReminders) {
      children.add(
        Container(
          margin: const EdgeInsets.only(left: 4),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.alarm,
                size: iconSize,
              ),
              Text(reminders.toString()),
            ],
          ),
        ),
      );
    }
    if (comments > 0 && showComments) {
      children.add(
        Container(
          margin: const EdgeInsets.only(left: 4),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.comment,
                size: iconSize,
              ),
              Text(comments.toString()),
            ],
          ),
        ),
      );
    }
    if (childTodos > 0 && showChildren) {
      children.add(
        Container(
          margin: const EdgeInsets.only(left: 4),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.format_strikethrough,
                size: iconSize,
              ),
              Text(childTodos.toString()),
            ],
          ),
        ),
      );
    }
    if (children.isEmpty) {
      return Container();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LocalDbState,
        ({int reminders, int comments, int childTodos})>(
      selector: (_, state) => (
        reminders: state.getTodoReminders(todo.id, true).length,
        comments: state.comments.where((f) => f.todo == todo.id).length,
        childTodos: state.todos
            .where((a) => a.parent == todo.id && a.completed == false)
            .length,
      ),
      builder: (context, counts, _) => _buildSecondRow(
        context,
        counts.comments,
        counts.reminders,
        counts.childTodos,
      ),
    );
  }
}

// Third row displays tags
class _TodoItemThirdRow extends StatelessWidget {
  const _TodoItemThirdRow({
    required this.todo,
  });

  final TodoData todo;

  @override
  Widget build(BuildContext context) {
    return Selector<LocalDbState, List<String>>(
      selector: (context, state) => state.getTodoTag(todo.id),
      builder: (context, tags, _) {
        if (tags.isEmpty) {
          return Container();
        }
        return Container(
          margin: const EdgeInsets.only(top: 4),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 100,
          ),
          child: TagsList(
            tags: tags,
          ),
        );
      },
    );
  }
}

class _SubtitleProject extends StatelessWidget {
  const _SubtitleProject({
    required this.todo,
  });

  final TodoData todo;

  Flex _buildContainer(ProjectData? project) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 8),
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 40),
          child: Text.rich(
            TextSpan(text: project?.title ?? "Inbox"),
            textScaler: TextScaler.linear(0.8),
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
    return todo.project == null
        ? _buildContainer(null)
        : Selector<LocalDbState, ProjectData?>(
            selector: (_, state) =>
                state.projects.where((f) => f.id == todo.project).firstOrNull,
            builder: (context, project, _) {
              return _buildContainer(project);
            },
          );
  }
}

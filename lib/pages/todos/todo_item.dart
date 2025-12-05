import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:watch_it/watch_it.dart';

import '../../db/db_crud_operations.dart';
import '../../helpers/date_fomatters.dart';
import '../../models/core.dart';
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

class TodoItem extends WatchingWidget {
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
          final localStateNotifier = GetIt.I<LocalStateNotifier>();
          localStateNotifier.toggleSelectedId(todo.id);
        };
      case TodoItemTapBehaviour.nothing:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminders = watchPropertyValue(
        (LocalDbState state) => state.getTodoReminders(todo.id, true).length);
    final comments = watchPropertyValue((LocalDbState state) =>
        state.comments.where((f) => f.todo == todo.id).length);
    final childTodos = watchPropertyValue((LocalDbState state) => state.todos
        .where((a) => a.parent == todo.id && a.completed == false)
        .length);
    if (tapBehaviour == TodoItemTapBehaviour.toggleSelection ||
        longPressBehaviour == TodoItemTapBehaviour.toggleSelection) {
      final selected = watchPropertyValue((LocalStateNotifier localState) =>
          localState.selectedTodoIds.contains(todo.id));
      return _TodoItem(
        todo: todo,
        selected: selected,
        dismissible: dismissible,
        dense: dense,
        elements: elements,
        onTap: action(tapBehaviour, context, todo),
        onLongPress: action(longPressBehaviour, context, todo),
        comments: comments,
        reminders: reminders,
        childTodos: childTodos,
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
      comments: comments,
      reminders: reminders,
      childTodos: childTodos,
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
    required this.comments,
    required this.childTodos,
    required this.reminders,
  });

  final TodoData todo;
  final bool selected;
  final bool dense;
  final bool dismissible;
  final List<TodoItemElements> elements;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final int comments;
  final int reminders;
  final int childTodos;

  void _selectDate(BuildContext context) {
    todoSelectDate(context, todo.due_date).then((dueDate) async {
      if (dueDate != null && context.mounted) {
        await GetIt.I<DbCrudOperations>()
            .todo
            .update([todo.id], TodoCompanion(due_date: drift.Value(dueDate)));
      }
    });
  }

  Future<bool?> _confirmDelete(BuildContext context) =>
      showConfirmationDialog(context);

  void _deleteTodo(BuildContext context) async {
    await GetIt.I<DbCrudOperations>().deleteTodosByIds([todo.id]);
  }

  bool get isThreeLines {
    if (elements.isEmpty) {
      return false;
    }
    if (todo.due_date == null &&
        reminders == 0 &&
        comments == 0 &&
        childTodos == 0 &&
        todo.tags.isEmpty) {
      return false;
    }
    return true;
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
          await GetIt.I<DbCrudOperations>().todo.update(
              [todo.id], TodoCompanion(completed: drift.Value(newValue)));
        },
      ),
      isThreeLine: isThreeLines,
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
                  comments: comments,
                  reminders: reminders,
                  childTodos: childTodos,
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
class _TodoItemSecondRow extends WatchingWidget {
  const _TodoItemSecondRow({
    required this.todo,
    required this.showDueDate,
    required this.showReminders,
    required this.showComments,
    required this.showChildren,
    required this.comments,
    required this.childTodos,
    required this.reminders,
  });

  final TodoData todo;
  final bool showDueDate;
  final bool showReminders;
  final bool showComments;
  final bool showChildren;
  final int comments;
  final int reminders;
  final int childTodos;

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    final iconSize =
        (ListTileTheme.of(context).subtitleTextStyle?.fontSize ?? 12) + 2;
    if (todo.due_date != null && showDueDate) {
      children.add(
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: Text(
            dueDateFormatter(
              todo.due_date,
            ),
          ),
        ),
      );
    }
    if (reminders > 0 && showReminders) {
      children.add(
        Container(
          margin: const EdgeInsets.only(right: 4),
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
          margin: const EdgeInsets.only(right: 4),
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
          margin: const EdgeInsets.only(right: 4),
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
}

// Third row displays tags
class _TodoItemThirdRow extends WatchingWidget {
  const _TodoItemThirdRow({
    required this.todo,
  });

  final TodoData todo;

  @override
  Widget build(BuildContext context) {
    final tags =
        watchPropertyValue((LocalDbState state) => state.getTodoTag(todo.id));
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
  }
}

class _SubtitleProject extends WatchingWidget {
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
    final project = watchPropertyValue((LocalDbState state) =>
        state.projects.where((f) => f.id == todo.project).firstOrNull);
    return _buildContainer(project);
  }
}

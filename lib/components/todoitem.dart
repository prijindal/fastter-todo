import 'package:fastter_dart/store/todocomments.dart';
import 'package:fastter_dart/store/todoreminders.dart';
import 'package:fastter_dart/store/todos.dart';
import 'package:fastter_todo/components/todoitemtitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/store/selectedtodos.dart';
import 'package:fastter_dart/fastter/fastter_bloc.dart';

import '../components/hexcolor.dart';
import '../helpers/todouihelpers.dart';
import 'label.dart';
import 'todoitemtoggle.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    @required this.todo,
    Key key,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) => _TodoItem(
        todo: todo,
        deleteTodo: () => fastterTodos.dispatch(DeleteEvent<Todo>(todo.id)),
        updateTodo: (updated) =>
            fastterTodos.dispatch(UpdateEvent<Todo>(todo.id, updated)),
        toggleSelected: () =>
            selectedTodosBloc.dispatch(ToggleSelectTodoEvent(todo.id)),
        reminders: fastterTodoReminders.currentState.items
            .where((reminder) =>
                reminder.todo != null &&
                reminder.completed == false &&
                reminder.todo.id == todo.id)
            .length,
        comments: fastterTodoComments.currentState.items
            .where(
                (comment) => comment.todo != null && comment.todo.id == todo.id)
            .length,
      );
}

class _TodoItem extends StatelessWidget {
  const _TodoItem({
    @required this.todo,
    @required this.deleteTodo,
    @required this.updateTodo,
    @required this.toggleSelected,
    @required this.reminders,
    @required this.comments,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final VoidCallback deleteTodo;
  final void Function(Todo) updateTodo;

  final VoidCallback toggleSelected;
  final int reminders;
  final int comments;

  void _selectDate(BuildContext context) {
    todoSelectDate(context, todo.dueDate).then((dueDate) {
      if (dueDate != null) {
        todo.dueDate = dueDate.dateTime;
      }
      updateTodo(
        todo,
      );
    });
  }

  Future<bool> _confirmDelete(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Are You sure?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
      );

  void _toggleCompleted(bool newvalue) {
    todo.completed = newvalue;
    updateTodo(todo);
  }

  TextStyle _subtitleTextStyle(ThemeData theme) {
    final style = theme.textTheme.body1;
    final color = theme.disabledColor;
    return style.copyWith(color: color);
  }

  Widget _buildProject(BuildContext context, {int flex = 1}) =>
      DefaultTextStyle(
        style: _subtitleTextStyle(Theme.of(context)),
        child: Flexible(
          flex: flex,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                constraints: const BoxConstraints(maxWidth: 200, maxHeight: 40),
                child: Text(
                  todo.project.title,
                ),
              ),
              Icon(
                Icons.group_work,
                color: HexColor(todo.project.color),
                size: 16,
              ),
            ],
          ),
        ),
      );

  Widget _buildDueDate(BuildContext context) => DefaultTextStyle(
        style: _subtitleTextStyle(Theme.of(context)),
        child: Flexible(
          flex: 0,
          child: Text(dueDateFormatter(todo.dueDate)),
        ),
      );

  Widget _buildSubtitleFirstRow(BuildContext context) {
    final children = <Widget>[];
    if (todo.dueDate == null && reminders == 0 && comments == 0) {
      return null;
    }
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
    if (todo.project != null) {
      children.add(_buildProject(context));
    }
    if (children.isEmpty) {
      return null;
    }
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final firstRow = _buildSubtitleFirstRow(context);
    if (todo.labels.isEmpty) {
      return firstRow;
    } else {
      return Column(
        children: <Widget>[
          Container(
            child: firstRow,
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 100,
            ),
            child: LabelsList(
              labels: todo.labels,
            ),
          )
        ],
      );
    }
  }

  Widget _buildTitle(BuildContext context) => TodoItemTitle(
        todo: todo,
      );

  Widget _buildBody(BuildContext context) => Dismissible(
        key: Key(todo.id),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            _selectDate(context);
            return false;
          } else if (direction == DismissDirection.endToStart) {
            return _confirmDelete(context);
          }
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            deleteTodo();
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context)
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
        child: BlocBuilder<SelectedTodosBloc, List<String>>(
          bloc: selectedTodosBloc,
          builder: (context, selectedTodos) => ListTile(
                leading: TodoItemToggle(
                  todo: todo,
                  toggleCompleted: _toggleCompleted,
                ),
                selected: selectedTodos.contains(todo.id),
                onTap: toggleSelected,
                title: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: _buildTitle(context),
                    ),
                    if (todo.dueDate == null &&
                        todo.project != null &&
                        reminders == 0 &&
                        comments == 0)
                      _buildProject(context, flex: 0),
                  ],
                ),
                subtitle: _buildSubtitle(context),
              ),
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        child: _buildBody(context),
      );
}

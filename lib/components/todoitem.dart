import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/todo.model.dart';
import '../models/project.model.dart';
import '../store/state.dart';
import '../fastter/fastter_action.dart';
import '../helpers/todouihelpers.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  TodoItem({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _TodoItem(
            todo: todo,
            deleteTodo: () => store.dispatch(DeleteItem<Todo>(todo.id)),
            updateTodo: (Todo updated) =>
                store.dispatch(UpdateItem<Todo>(todo.id, updated)));
      },
    );
  }
}

class _TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback deleteTodo;
  final void Function(Todo) updateTodo;

  _TodoItem({
    Key key,
    @required this.todo,
    @required this.deleteTodo,
    @required this.updateTodo,
  }) : super(key: key);

  _selectDate(BuildContext context) {
    Future<DateTime> selectedDate = todoSelectDate(context);
    selectedDate.then((dueDate) {
      // Update
      todo.dueDate = dueDate;
      updateTodo(
        todo,
      );
    });
  }

  Future<bool> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text("Are You sure?"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
    );
  }

  String dueDateFormatter(DateTime dueDate) {
    DateTime now = DateTime.now();
    Duration diff = dueDate.difference(now);
    if (diff.inDays == 0) {
      return diff.inSeconds > 0 ? "Tomorrow" : "Today";
    } else if (diff.inDays < 7 && diff.inDays > 0) {
      return DateFormat.EEEE().format(dueDate);
    } else if (now.year == dueDate.year) {
      return DateFormat.MMMd().format(dueDate);
    }
    return DateFormat.yMMMd().format(dueDate);
  }

  String _subtitleText() {
    String subtitle = "";
    if (todo.project != null) {
      subtitle += todo.project.title + '\n';
    }
    if (todo.dueDate != null) {
      subtitle += dueDateFormatter(todo.dueDate);
    }
    return subtitle;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: new Key(todo.id),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await _selectDate(context);
          return false;
        } else if (direction == DismissDirection.endToStart) {
          return await _confirmDelete(context);
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          deleteTodo();
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("${todo.title} dismissed")));
        }
      },
      background: Flex(
        direction: Axis.horizontal,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.calendar_today),
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
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.delete),
          ),
        ],
      ),
      child: ListTile(
        title: Text(todo.title),
        subtitle: Text(_subtitleText()),
      ),
    );
  }
}

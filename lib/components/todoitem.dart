import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/todo.model.dart';
import '../store/state.dart';
import '../fastter/fastter_action.dart';
import '../helpers/todouihelpers.dart';
import '../components/hexcolor.dart';
import '../store/selectedtodos.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final bool showProject;
  final bool showDueDate;

  TodoItem({
    Key key,
    @required this.todo,
    this.showProject = true,
    this.showDueDate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _TodoItem(
          todo: todo,
          deleteTodo: () => store.dispatch(DeleteItem<Todo>(todo.id)),
          updateTodo: (Todo updated) =>
              store.dispatch(UpdateItem<Todo>(todo.id, updated)),
          showProject: showProject,
          showDueDate: showDueDate,
          selected: store.state.selectedTodos.contains(todo.id),
          toggleSelected: () => store.dispatch(ToggleSelectTodo(todo.id)),
        );
      },
    );
  }
}

class _TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback deleteTodo;
  final void Function(Todo) updateTodo;

  final bool selected;
  final VoidCallback toggleSelected;

  final bool showProject;
  final bool showDueDate;

  _TodoItem({
    Key key,
    @required this.todo,
    @required this.deleteTodo,
    @required this.updateTodo,
    @required this.selected,
    @required this.toggleSelected,
    this.showProject = true,
    this.showDueDate = true,
  }) : super(key: key);

  _selectDate(BuildContext context) {
    Future<DateTime> selectedDate = todoSelectDate(context, todo.dueDate);
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

  void _toggleCompleted(bool newvalue) {
    todo.completed = newvalue;
    updateTodo(todo);
  }

  Widget _buildSubtitle() {
    List<Widget> children = [];
    if (todo.dueDate != null && showDueDate) {
      children.add(
        Flexible(
          child: Text(dueDateFormatter(todo.dueDate)),
        ),
      );
    }
    if (todo.project != null && showProject) {
      children.add(
        Flexible(
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(todo.project.title),
              ),
              Icon(
                Icons.group_work,
                color: HexColor(todo.project.color),
                size: 16.0,
              ),
            ],
          ),
        ),
      );
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
      child: Material(
        child: ListTile(
          leading: GestureDetector(
            onTap: () {
              _toggleCompleted(!(todo.completed == true));
            },
            child: Container(
              width: 48.0,
              height: 48.0,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 16.0,
                  height: 16.0,
                  decoration: BoxDecoration(
                    color: (todo.completed == true)
                        ? Theme.of(context).accentColor
                        : Colors.transparent,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                  ),
                ),
              ),
            ),
          ),
          isThreeLine: false,
          selected: selected,
          onTap: () {
            toggleSelected();
          },
          title: Text(todo.title),
          subtitle: _buildSubtitle(),
        ),
      ),
    );
  }
}

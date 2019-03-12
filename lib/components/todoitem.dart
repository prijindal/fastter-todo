import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/hexcolor.dart';
import '../fastter/fastter_action.dart';
import '../helpers/todouihelpers.dart';
import '../models/todo.model.dart';
import '../store/selectedtodos.dart';
import '../store/state.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    @required this.todo,
    Key key,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _TodoItem(
              todo: todo,
              deleteTodo: () => store.dispatch(DeleteItem<Todo>(todo.id)),
              updateTodo: (updated) =>
                  store.dispatch(UpdateItem<Todo>(todo.id, updated)),
              selected: store.state.selectedTodos.contains(todo.id),
              toggleSelected: () => store.dispatch(ToggleSelectTodo(todo.id)),
            ),
      );
}

class _TodoItem extends StatelessWidget {
  const _TodoItem({
    @required this.todo,
    @required this.deleteTodo,
    @required this.updateTodo,
    @required this.selected,
    @required this.toggleSelected,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final VoidCallback deleteTodo;
  final void Function(Todo) updateTodo;

  final bool selected;
  final VoidCallback toggleSelected;

  void _selectDate(BuildContext context) {
    todoSelectDate(context, todo.dueDate).then((dueDate) {
      todo.dueDate = dueDate;
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

  Widget _buildSubtitle() {
    final children = <Widget>[];
    if (todo.dueDate != null) {
      children.add(
        Flexible(
          child: Text(dueDateFormatter(todo.dueDate)),
        ),
      );
    }
    if (todo.project != null) {
      children.add(
        Flexible(
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(todo.project.title),
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
        child: Material(
          child: ListTile(
            leading: GestureDetector(
              onTap: () {
                _toggleCompleted(!(todo.completed == true));
              },
              child: Container(
                width: 48,
                height: 48,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: (todo.completed == true)
                          ? Theme.of(context).accentColor
                          : Colors.transparent,
                      border: Border.all(color: Colors.black),
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                ),
              ),
            ),
            selected: selected,
            onTap: toggleSelected,
            title: Text(todo.title),
            subtitle: _buildSubtitle(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => _buildBody(context);
}

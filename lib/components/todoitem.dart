import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/hexcolor.dart';
import 'package:fastter_dart/fastter/fastter_action.dart';
import '../helpers/todouihelpers.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/store/selectedtodos.dart';
import 'package:fastter_dart/store/state.dart';
import 'label.dart';

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
              labels: store.state.labels.items
                  .where((label) => todo.labels
                      .map<String>((todolabel) => todolabel.id)
                      .toList()
                      .contains(label.id))
                  .toList(),
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
    @required this.labels,
    @required this.deleteTodo,
    @required this.updateTodo,
    @required this.selected,
    @required this.toggleSelected,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final List<Label> labels;
  final VoidCallback deleteTodo;
  final void Function(Todo) updateTodo;

  final bool selected;
  final VoidCallback toggleSelected;

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
    final TextStyle style = theme.textTheme.body1;
    Color color = theme.disabledColor;
    return style.copyWith(color: color);
  }

  Widget _buildProject(BuildContext context, {int flex = 1}) {
    return DefaultTextStyle(
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
              constraints: BoxConstraints(maxWidth: 200, maxHeight: 40),
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
  }

  _buildDueDate(BuildContext context) {
    return DefaultTextStyle(
      style: _subtitleTextStyle(Theme.of(context)),
      child: Flexible(
        flex: 0,
        child: Text(dueDateFormatter(todo.dueDate)),
      ),
    );
  }

  Widget _buildSubtitleFirstRow(BuildContext context) {
    final children = <Widget>[];
    if (todo.dueDate == null) {
      return null;
    }
    children.add(_buildDueDate(context));
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
    if (labels.isEmpty) {
      return firstRow;
    } else {
      return Column(
        children: <Widget>[
          Container(
            child: firstRow,
          ),
          Container(
            margin: EdgeInsets.only(top: 4.0),
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

  Widget _buildTitle(BuildContext context) {
    return Text(
      todo.title,
      style: TextStyle(
        decoration: todo.completed == true
            ? TextDecoration.lineThrough
            : TextDecoration.none,
      ),
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
        child: ListTile(
          leading: InkWell(
            onTap: () {
              _toggleCompleted(!(todo.completed == true));
            },
            child: Container(
              constraints: BoxConstraints.expand(
                width: 48,
                height: 48,
              ),
              child: Center(
                child: AnimatedContainer(
                  constraints: BoxConstraints(
                    maxWidth: 16,
                    maxHeight: 16,
                  ),
                  duration: const Duration(milliseconds: 300),
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
          title: todo.dueDate != null || todo.project == null
              ? _buildTitle(context)
              : Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: _buildTitle(context),
                    ),
                    _buildProject(context, flex: 0),
                  ],
                ),
          subtitle: _buildSubtitle(context),
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

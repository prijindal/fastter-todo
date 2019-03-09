import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'projectdropdown.dart';

import '../models/base.model.dart';
import '../helpers/navigator.dart';
import '../helpers/todouihelpers.dart';
import '../models/todo.model.dart';
import '../models/project.model.dart';
import '../fastter/fastter_action.dart';
import '../store/state.dart';

import '../screens/todoedit.dart';

class TodoEditBar extends StatelessWidget {
  TodoEditBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        void onMarkCompleted() {
          store.state.selectedTodos.forEach((todoid) {
            Todo todo = store.state.todos.items
                .singleWhere((item) => item.id == todoid);
            todo.completed = true;
            store.dispatch(UpdateItem<Todo>(todoid, todo));
          });
        }

        void onChangeDate(DateTime date) {
          store.state.selectedTodos.forEach((todoid) {
            Todo todo = store.state.todos.items
                .singleWhere((item) => item.id == todoid);
            todo.dueDate = date;
            store.dispatch(UpdateItem<Todo>(todoid, todo));
          });
        }

        void onChangeProject(Project project) {
          store.state.selectedTodos.forEach((todoid) {
            Todo todo = store.state.todos.items
                .singleWhere((item) => item.id == todoid);
            todo.project = project;
            store.dispatch(UpdateItem<Todo>(todoid, todo));
          });
        }

        return _TodoEditBar(
          selectedTodos: store.state.selectedTodos,
          onMarkCompleted: onMarkCompleted,
          todos: store.state.todos,
          onChangeDate: onChangeDate,
          onChangeProject: onChangeProject,
        );
      },
    );
  }
}

class _TodoEditBar extends StatefulWidget {
  final List<String> selectedTodos;
  final ListState<Todo> todos;
  final VoidCallback onMarkCompleted;
  final void Function(DateTime) onChangeDate;
  final void Function(Project) onChangeProject;

  _TodoEditBar({
    Key key,
    @required this.todos,
    @required this.selectedTodos,
    @required this.onMarkCompleted,
    @required this.onChangeDate,
    @required this.onChangeProject,
  }) : super(key: key);

  __TodoEditBarState createState() => __TodoEditBarState();
}

class __TodoEditBarState extends State<_TodoEditBar> {
  Future<void> _showDatePicker() async {
    DateTime selectedDate = await todoSelectDate(context);
    widget.onChangeDate(selectedDate);
  }

  Widget _buildMarkCompletedButton() {
    return IconButton(
      icon: Icon(Icons.check),
      onPressed: widget.onMarkCompleted,
    );
  }

  Widget _buildChangeDateButton() {
    return IconButton(
      icon: Icon(
        Icons.calendar_today,
        color: Theme.of(context).accentColor,
      ),
      onPressed: _showDatePicker,
    );
  }

  Widget _buildEditButton() {
    String todoid = widget.selectedTodos[0];
    Todo todo = widget.todos.items.singleWhere((item) => item.id == todoid);
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        mainNavigatorKey.currentState.push(
          MaterialPageRoute(
            builder: (context) => TodoEditScreen(
                  todo: todo,
                ),
          ),
        );
      },
    );
  }

  Widget _buildChangeProjectButton() {
    return ProjectDropdown(
      onSelected: widget.onChangeProject,
    );
  }

  List<Widget> _buildButtons() {
    if (widget.selectedTodos.length == 1) {
      return <Widget>[
        _buildChangeDateButton(),
        _buildEditButton(),
        _buildChangeProjectButton(),
      ];
    }
    return <Widget>[
      _buildMarkCompletedButton(),
      _buildChangeDateButton(),
      _buildChangeProjectButton(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildButtons(),
        ),
      ),
    );
  }
}

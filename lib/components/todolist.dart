import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../components/homeappbar.dart';
import '../components/todoinput.dart';
import '../components/homeappdrawer.dart';
import '../components/todoitem.dart';
import '../fastter/fastter_action.dart';
import '../store/state.dart';

class TodoList extends StatelessWidget {
  final Map<String, dynamic> filter;
  final String title;

  TodoList({Key key, this.filter = const {}, this.title = "Todos"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _TodoList(
            todos: store.state.todos,
            title: title,
            syncStart: () {
              var action = StartSync<Todo>(filter);
              store.dispatch(action);
              return action.completer;
            });
      },
    );
  }
}

class _TodoList extends StatefulWidget {
  final ListState<Todo> todos;
  final Completer Function() syncStart;
  final String title;

  _TodoList({
    Key key,
    @required this.todos,
    @required this.syncStart,
    this.title = "Todos",
  }) : super(key: key);

  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<_TodoList> {
  @override
  void initState() {
    widget.syncStart();
    super.initState();
  }

  Widget buildBody() {
    if (widget.todos.fetching) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: ListView(
            children: widget.todos.items
                .map(
                  (todo) => TodoItem(
                        todo: todo,
                      ),
                )
                .toList(),
          ),
        ),
        TodoInput(),
      ],
    );
  }

  Future<void> _onRefresh() {
    Completer completer = widget.syncStart();
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: widget.title,
      ),
      drawer: HomeAppDrawer(),
      body: RefreshIndicator(
        child: buildBody(),
        onRefresh: _onRefresh,
      ),
    );
  }
}

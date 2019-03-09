import 'dart:io';
import 'dart:async';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../components/todoinput.dart';
import '../components/todoitem.dart';
import '../fastter/fastter_action.dart';
import '../store/state.dart';
import '../store/todos.dart';
import 'todoeditbar.dart';

class TodoList extends StatelessWidget {
  final Map<String, dynamic> filter;
  final String title;
  final bool showProject;
  final bool showDueDate;

  TodoList({
    Key key,
    this.filter = const {},
    this.title = "Todos",
    this.showProject = true,
    this.showDueDate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _TodoList(
          selectedTodos: store.state.selectedTodos,
          todos: ListState<Todo>(
            fetching: store.state.todos.fetching,
            adding: store.state.todos.adding,
            updating: store.state.todos.updating,
            deleting: store.state.todos.deleting,
            items: store.state.todos.items
                .where((todo) => fastterTodos.filterObject(todo, filter))
                .toList(),
          ),
          title: title,
          syncStart: () {
            var action = StartSync<Todo>();
            store.dispatch(action);
            return action.completer;
          },
          showProject: showProject,
          showDueDate: showDueDate,
        );
      },
    );
  }
}

class _TodoList extends StatefulWidget {
  final ListState<Todo> todos;
  final Completer Function() syncStart;
  final String title;
  final bool showProject;
  final bool showDueDate;
  final List<String> selectedTodos;

  _TodoList({
    Key key,
    @required this.todos,
    @required this.syncStart,
    @required this.selectedTodos,
    this.title = "Todos",
    this.showProject = true,
    this.showDueDate = true,
  }) : super(key: key);

  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<_TodoList> {
  bool showInput = false;

  @override
  void initState() {
    widget.syncStart();
    super.initState();
  }

  Positioned _buildBottom() {
    double position = widget.selectedTodos.isEmpty && !showInput ? 48.0 : 0;
    return Positioned(
      bottom: position,
      right: position,
      child: Container(
        child: widget.selectedTodos.isEmpty
            ? (showInput
                ? TodoInput(
                    onBackButton: () {
                      setState(() {
                        showInput = false;
                      });
                    },
                  )
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        showInput = true;
                      });
                    },
                  ))
            : TodoEditBar(),
      ),
    );
  }

  Widget _buildBody() {
    if (widget.todos.fetching && widget.todos.items.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
      children: [
        Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: widget.todos.items.length,
                itemBuilder: (context, index) => TodoItem(
                      todo: widget.todos.items[index],
                      showProject: widget.showProject,
                      showDueDate: widget.showDueDate,
                    ),
              ),
            ),
          ],
        ),
        _buildBottom(),
      ],
    );
  }

  Future<void> _onRefresh() {
    Completer completer = widget.syncStart();
    return completer.future;
  }

  Widget _buildChild() {
    return RefreshIndicator(
      child: _buildBody(),
      onRefresh: _onRefresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return OfflineBuilder(
        connectivityBuilder: (context, connectivity, child) {
          final bool connected = connectivity != ConnectivityResult.none;
          return new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                padding: EdgeInsets.only(top: connected ? 0 : 24.0),
                child: child,
              ),
              Positioned(
                height: 32.0,
                left: 0.0,
                right: 0.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  color: connected ? Colors.transparent : Color(0xFFEE4400),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: connected
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('OFFLINE'),
                              SizedBox(width: 8.0),
                              SizedBox(
                                width: 12.0,
                                height: 12.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          );
        },
        child: _buildChild(),
      );
    }
    return _buildChild();
  }
}

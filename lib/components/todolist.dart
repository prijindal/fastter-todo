import 'dart:async';
import 'dart:io';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../components/homeappbar.dart';
import '../components/todoinput.dart';
import '../components/todoitem.dart';
import '../fastter/fastter_action.dart';
import '../models/base.model.dart';
import '../models/project.model.dart';
import '../models/todo.model.dart';
import '../store/state.dart';
import '../store/todos.dart';
import 'todoeditbar.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    this.filter = const <String, dynamic>{},
    this.title = 'Todos',
    Key key,
  }) : super(key: key);

  final Map<String, dynamic> filter;
  final String title;
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _TodoList(
              selectedTodos: store.state.selectedTodos,
              projects: store.state.projects,
              todos: ListState<Todo>(
                fetching: store.state.todos.fetching,
                adding: store.state.todos.adding,
                updating: store.state.todos.updating,
                deleting: store.state.todos.deleting,
                items: store.state.todos.items
                    .where((todo) => fastterTodos.filterObject(todo, filter))
                    .toList(),
              ),
              filter: filter,
              title: title,
              syncStart: () {
                final action = StartSync<Todo>();
                store.dispatch(action);
                return action.completer;
              },
            ),
      );
}

class _TodoList extends StatefulWidget {
  const _TodoList({
    @required this.todos,
    @required this.projects,
    @required this.syncStart,
    @required this.selectedTodos,
    this.filter = const <String, dynamic>{},
    this.title = 'Todos',
    Key key,
  }) : super(key: key);

  final ListState<Todo> todos;
  final ListState<Project> projects;
  final Completer Function() syncStart;
  final String title;
  final List<String> selectedTodos;
  final Map<String, dynamic> filter;

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<_TodoList> {
  bool showInput = false;

  Positioned _buildBottom() {
    final position = widget.selectedTodos.isEmpty && !showInput ? 48.0 : 0.0;
    return Positioned(
      bottom: position,
      right: position,
      child: Container(
        child: widget.selectedTodos.isEmpty
            ? (showInput
                ? TodoInput(
                    project: (widget.filter.containsKey('project') &&
                            widget.projects.items.isNotEmpty)
                        ? widget.projects.items.singleWhere(
                            (project) => project.id == widget.filter['project'],
                            orElse: () => null)
                        : null,
                    onBackButton: () {
                      setState(() {
                        showInput = false;
                      });
                    },
                  )
                : FloatingActionButton(
                    child: const Icon(Icons.add),
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
    if (widget.todos.fetching && widget.todos.items.isEmpty) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    }
    return Stack(
      children: [
        widget.todos.items.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('No Tasks yet'),
                    RaisedButton(
                      child: const Text('Add a todo'),
                      onPressed: () {
                        setState(() {
                          showInput = true;
                        });
                      },
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: widget.todos.items.length,
                itemBuilder: (context, index) => TodoItem(
                      todo: widget.todos.items[index],
                    ),
              ),
        _buildBottom(),
      ],
    );
  }

  Future<void> _onRefresh() {
    final completer = widget.syncStart();
    return completer.future;
  }

  Widget _buildChild() => RefreshIndicator(
        child: _buildBody(),
        onRefresh: _onRefresh,
      );

  Widget _build() {
    if (Platform.isAndroid || Platform.isIOS) {
      return OfflineBuilder(
        connectivityBuilder: (context, connectivity, child) {
          final connected = connectivity != ConnectivityResult.none;
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                padding: EdgeInsets.only(top: connected ? 0 : 24.0),
                child: child,
              ),
              Positioned(
                height: 32,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  color:
                      connected ? Colors.transparent : const Color(0xFFEE4400),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: connected
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text('OFFLINE'),
                              SizedBox(width: 8),
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: HomeAppBar(
          filter: widget.filter,
        ),
        body: _build(),
      );
}

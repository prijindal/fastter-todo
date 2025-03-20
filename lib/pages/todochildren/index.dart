import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/core.dart';
import '../../models/local_db_state.dart';
import '../todos/todo_item.dart';
import '../todos/todoinputbar.dart';

@RoutePage()
class TodoChildrenScreen extends WatchingWidget {
  const TodoChildrenScreen({
    super.key,
    @PathParam() required this.todoId,
  });

  final String todoId;

  @override
  Widget build(BuildContext context) {
    final todo = watchPropertyValue(
        (LocalDbState state) => state.todos.firstWhere((f) => f.id == todoId));
    return _TodoChildrenScreen(
      todo: todo,
    );
  }
}

class _TodoChildrenScreen extends StatelessWidget {
  const _TodoChildrenScreen({required this.todo});

  final TodoData todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: _TodoSubTaskList(
        todo: todo,
        allowAddition: true,
      ),
    );
  }
}

class _TodoSubTaskList extends WatchingStatefulWidget {
  const _TodoSubTaskList({
    required this.todo,
    required this.allowAddition,
  });

  final TodoData todo;
  final bool allowAddition;

  @override
  State<_TodoSubTaskList> createState() => _TodoSubTaskListState();
}

class _TodoSubTaskListState extends State<_TodoSubTaskList> {
  bool _adding = false;

  @override
  Widget build(BuildContext context) {
    final children = watchPropertyValue((LocalDbState state) =>
        state.todos.where((a) => a.parent == widget.todo.id).toList());
    return ListView(
      shrinkWrap: true,
      children: [
        TodoItem(
          todo: widget.todo,
          dense: true,
          tapBehaviour: TodoItemTapBehaviour.openTodoPage,
          dismissible: false,
          elements: [],
        ),
        Container(
          margin: const EdgeInsets.only(left: 24),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...children.map(
                (a) => _TodoSubTaskList(
                  todo: a,
                  allowAddition: false,
                ),
              ),
              if (!_adding && widget.allowAddition)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _adding = true;
                    });
                  },
                  icon: Icon(Icons.add),
                ),
              if (_adding)
                TodoInputBar(
                  parentTodo: widget.todo.id,
                  initialProject: widget.todo.project,
                  additionalFields: false,
                  initialPipeline: widget.todo.pipeline,
                  onBackButton: () {
                    setState(() {
                      _adding = false;
                    });
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

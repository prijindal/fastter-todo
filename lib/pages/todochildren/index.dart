import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/core.dart';
import '../../models/local_db_state.dart';
import '../todos/todo_item.dart';
import '../todos/todoinputbar.dart';

@RoutePage()
class TodoChildrenScreen extends StatelessWidget {
  const TodoChildrenScreen({
    super.key,
    @PathParam() required this.todoId,
  });

  final String todoId;

  @override
  Widget build(BuildContext context) => Consumer<LocalDbState>(
        builder: (context, localDbState, _) => _TodoChildrenScreen(
          todo: localDbState.todos.firstWhere((f) => f.id == todoId),
        ),
      );
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
      ),
    );
  }
}

class _TodoSubTaskList extends StatefulWidget {
  const _TodoSubTaskList({
    required this.todo,
  });

  final TodoData todo;

  @override
  State<_TodoSubTaskList> createState() => _TodoSubTaskListState();
}

class _TodoSubTaskListState extends State<_TodoSubTaskList> {
  bool _adding = false;

  @override
  Widget build(BuildContext context) {
    final children = Provider.of<LocalDbState>(context)
        .todos
        .where((a) => a.parent == widget.todo.id)
        .toList();
    return ListView(
      shrinkWrap: true,
      children: [
        TodoItem(
          todo: widget.todo,
          allowSelection: false,
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
                ),
              ),
              if (!_adding)
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
                  allowProjectSelection: false,
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

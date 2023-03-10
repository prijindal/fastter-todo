import '../models/base.model.dart';
import '../store/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fastter/fastter_bloc.dart';
import '../models/todo.model.dart';

import '../components/todoitemtoggle.dart';
import 'todoedit.dart';

class TodoSubtasks extends StatelessWidget {
  const TodoSubtasks({
    required this.todo,
  });
  final Todo todo;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(todo.title),
        ),
        body: _TodoSubTaskItem(
          todo: todo,
        ),
      );
}

class _TodoSubTaskList extends StatelessWidget {
  const _TodoSubTaskList({
    required this.todo,
  });
  final Todo todo;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterBloc<Todo>, ListState<Todo>>(
        bloc: fastterTodos,
        builder: (context, state) => _TodoSubTaskListComponent(
          todo: todo,
          children: state.items
              .where((todo) =>
                  todo.parent != null && todo.parent?.id == this.todo.id)
              .toList()
            ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
          updateTodo: (id, updated) =>
              fastterTodos.add(UpdateEvent<Todo>(id, updated)),
        ),
      );
}

class _TodoSubTaskListComponent extends StatelessWidget {
  const _TodoSubTaskListComponent({
    required this.todo,
    required this.children,
    required this.updateTodo,
  });
  final Todo todo;
  final List<Todo> children;
  final void Function(String, Todo) updateTodo;

  @override
  Widget build(BuildContext context) => Column(
        children: children
            .map(
              (child) => _TodoSubTaskItem(
                todo: child,
              ),
            )
            .toList(),
      );
}

class _TodoSubTaskItem extends StatelessWidget {
  const _TodoSubTaskItem({
    required this.todo,
  });

  final Todo todo;
  @override
  Widget build(BuildContext context) => _TodoSubTaskItemComponent(
        todo: todo,
        updateTodo: (updated) =>
            fastterTodos.add(UpdateEvent<Todo>(todo.id, updated)),
        addTodo: (newtodo) => fastterTodos.add(AddEvent<Todo>(newtodo)),
        deleteTodo: () => fastterTodos.add(DeleteEvent<Todo>(todo.id)),
      );
}

class _TodoSubTaskItemComponent extends StatefulWidget {
  const _TodoSubTaskItemComponent({
    required this.todo,
    required this.updateTodo,
    required this.addTodo,
    required this.deleteTodo,
  });

  final Todo todo;
  final void Function(Todo) updateTodo;
  final void Function(Todo) addTodo;
  final VoidCallback deleteTodo;

  @override
  _TodoSubTaskItemState createState() => _TodoSubTaskItemState();
}

class _TodoSubTaskItemState extends State<_TodoSubTaskItemComponent> {
  bool adding = false;
  String title = '';

  void _addSubtask() {
    widget.addTodo(
      Todo(
        completed: false,
        dueDate: null,
        parent: widget.todo,
        project: widget.todo.project,
        title: title,
      ),
    );
    setState(() {
      adding = false;
      title = '';
    });
  }

  void _editTodo() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => TodoEditScreen(
          todo: widget.todo,
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are You sure?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      widget.deleteTodo();
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ListTile(
            dense: true,
            leading: TodoItemToggle(
              todo: widget.todo,
              toggleCompleted: (newvalue) {
                widget.todo.completed = newvalue;
                widget.updateTodo(widget.todo);
              },
            ),
            title: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 300,
                    maxHeight: 40,
                  ),
                  child: Text(
                    widget.todo.title,
                    style: TextStyle(
                      decoration: widget.todo.completed == true
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _editTodo,
                ),
                if (widget.todo.parent != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _confirmDelete,
                  ),
                if (!adding)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() {
                      adding = true;
                    }),
                  )
              ],
            ),
          ),
          if (adding)
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                  prefix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() {
                      adding = false;
                    }),
                  ),
                  suffix: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _addSubtask,
                  )),
              onChanged: (title) => setState(() {
                this.title = title;
              }),
              onSubmitted: (_) => _addSubtask(),
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
            child: _TodoSubTaskList(
              todo: widget.todo,
            ),
          ),
        ],
      );
}

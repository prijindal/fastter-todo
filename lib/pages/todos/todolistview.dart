import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/core.dart';
import '../../models/local_db_state.dart';
import 'todo_item.dart';

class TodosListView extends StatefulWidget {
  const TodosListView({
    super.key,
    required this.todos,
    this.shrinkWrap = false,
    this.dismissible = true,
    required this.todoItemTapBehaviour,
    this.showChildren = false,
    required this.todoItemLongPressBehaviour,
  });

  final List<TodoData> todos;
  final bool shrinkWrap;
  final bool dismissible;
  final TodoItemTapBehaviour todoItemTapBehaviour;
  final TodoItemTapBehaviour todoItemLongPressBehaviour;
  final bool showChildren;

  @override
  State<TodosListView> createState() => _TodosListViewState();
}

class _TodosListViewState extends State<TodosListView> {
  bool completedExpanded = false;

  int get length {
    // If there are no completed widget we won't show the bottom expansion button
    var length = widget.todos.where((a) => a.completed == false).length;
    if (length != widget.todos.length) {
      // If there are any completed, we will show the bottom expansion button, so add 1
      length = length + 1;
      if (completedExpanded) {
        // If expansion is open, we make length to all + 1
        length = length + widget.todos.where((a) => a.completed == true).length;
      }
    }
    return length;
  }

  int get expansionBoxIndex {
    return widget.todos.where((a) => a.completed == false).length;
  }

  int get completedLength {
    return widget.todos.where((a) => a.completed == true).length;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.todos.isEmpty) {
      return Center(child: Text("Add some entries"));
    }
    return ListView.builder(
      shrinkWrap: widget.shrinkWrap,
      padding: EdgeInsets.only(bottom: 60.0),
      itemCount: length,
      itemBuilder: (context, index) {
        if (index == expansionBoxIndex) {
          return ListTile(
            dense: true,
            title: Text("$completedLength completed tasks"),
            trailing: Icon(completedExpanded == true
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down),
            onTap: () {
              setState(() {
                completedExpanded = !completedExpanded;
              });
            },
          );
        }
        if (index > expansionBoxIndex) {
          index = index - 1;
        }
        final todo = widget.todos[index];
        if (widget.showChildren) {
          return _TodoItemCardWithChildren(
            todo: todo,
            dismissible: widget.dismissible,
            todoItemTapBehaviour: widget.todoItemTapBehaviour,
            todoItemLongPressBehaviour: widget.todoItemLongPressBehaviour,
          );
        }
        return TodoItem(
          key: Key("TodoItem${todo.id}"),
          todo: todo,
          dismissible: widget.dismissible,
          tapBehaviour: widget.todoItemTapBehaviour,
          longPressBehaviour: widget.todoItemLongPressBehaviour,
        );
      },
    );
  }
}

class _TodoItemCardWithChildren extends WatchingWidget {
  const _TodoItemCardWithChildren(
      {required this.todo,
      required this.dismissible,
      required this.todoItemTapBehaviour,
      required this.todoItemLongPressBehaviour});

  final TodoData todo;
  final bool dismissible;
  final TodoItemTapBehaviour todoItemTapBehaviour;
  final TodoItemTapBehaviour todoItemLongPressBehaviour;

  @override
  Widget build(BuildContext context) {
    final children = watchPropertyValue((LocalDbState state) =>
        state.todos.where((a) => a.parent == todo.id).toList());
    return Card(
      elevation: 4,
      child: Column(
        children: [
          TodoItem(
            key: Key("TodoItem${todo.id}"),
            todo: todo,
            dismissible: dismissible,
            tapBehaviour: todoItemTapBehaviour,
            longPressBehaviour: todoItemLongPressBehaviour,
          ),
          if (children.isNotEmpty)
            Container(
              padding: const EdgeInsets.only(
                left: 24.0,
                bottom: 8.0,
              ),
              child: Column(
                children: children
                    .map(
                      (a) => TodoItem(
                        todo: a,
                        dense: true,
                        tapBehaviour: TodoItemTapBehaviour.openTodoPage,
                        dismissible: false,
                        elements: [],
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}

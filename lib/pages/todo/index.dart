import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/core.dart';
import '../../models/local_db_state.dart';

@RoutePage()
class TodoScreen extends StatelessWidget {
  const TodoScreen({
    super.key,
    @PathParam() required this.todoId,
  });

  final String todoId;

  @override
  Widget build(BuildContext context) => Selector<LocalDbState, TodoData>(
        selector: (_, state) => state.todos.where((a) => a.id == todoId).first,
        builder: (context, todo, _) => _TodoScreen(
          todo: todo,
        ),
      );
}

class _TodoScreen extends StatelessWidget {
  const _TodoScreen({
    required this.todo,
  });

  final TodoData todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              // await Provider.of<DbSelector>(context, listen: false).database.managers.todo
              //     .filter((a) => a.id.equals(todo.id))
              //     .delete();
              // await AutoRouter.of(context).maybePop();
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
    );
  }
}

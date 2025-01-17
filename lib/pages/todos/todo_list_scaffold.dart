import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/adaptive_scaffold.dart';
import '../../components/main_drawer.dart';
import '../../helpers/todos_filters.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';
import '../../models/local_state.dart';
import '../todo/index.dart';
import 'todoeditbar/index.dart';
import 'todoinputbar.dart';
import 'todolist.dart';

class TodoListScaffold extends StatefulWidget {
  const TodoListScaffold({
    super.key,
    required this.appBar,
    required this.filters,
  });

  final TodosFilters filters;

  /// An app bar to display at the top of the scaffold.
  final PreferredSizeWidget appBar;

  @override
  State<TodoListScaffold> createState() => _TodoListScaffoldState();
}

class _TodoListScaffoldState extends State<TodoListScaffold> {
  bool _showInput = false;

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _showInput = true;
        });
      },
      tooltip: 'New Todo',
      key: Key("New Todo"),
      child: const Icon(Icons.add),
    );
  }

  Widget? _buildBottom(List<String> selectedTodoIds) {
    if (_showInput) {
      return TodoInputBar(
        initialProject: widget.filters.projectFilter,
        onBackButton: () {
          setState(() {
            _showInput = false;
          });
        },
      );
    }
    if (selectedTodoIds.isEmpty) {
      return null;
    }
    return TodoEditBar();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalStateNotifier>(
      child: TodoList(
        filters: widget.filters,
      ),
      builder: (_, localState, list) => AdaptiveScaffold(
        appBar: widget.appBar,
        drawer: MainDrawer(),
        body: list!,
        secondaryBody: localState.selectedTodoIds.length != 1
            ? null
            : Selector<LocalDbState, TodoData>(
                selector: (_, state) => state.todos
                    .where((a) => a.id == localState.selectedTodoIds.first)
                    .first,
                builder: (context, todo, __) => TodoEditBody(
                  todo: todo,
                ),
              ),
        floatingActionButton: _showInput == true ? null : _buildFab(),
        bottomSheet: _buildBottom(localState.selectedTodoIds),
      ),
    );
  }
}

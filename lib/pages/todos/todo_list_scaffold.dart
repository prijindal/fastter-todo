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

class TodoListScaffold extends StatelessWidget {
  const TodoListScaffold({
    super.key,
    required this.appBar,
    required this.filters,
  });

  final TodosFilters filters;

  /// An app bar to display at the top of the scaffold.
  final PreferredSizeWidget appBar;

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (context) => TodoInputBar(
            initialProject: filters.projectFilter,
            onBackButton: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
      tooltip: 'New Todo',
      key: Key("New Todo"),
      child: const Icon(Icons.add),
    );
  }

  Widget? _buildBottom(BuildContext context, List<String> selectedTodoIds) {
    if (selectedTodoIds.isEmpty) {
      return null;
    }
    return BottomSheet(
      onClosing: () {
        Provider.of<LocalStateNotifier>(context, listen: false)
            .clearSelectedTodoIds();
      },
      builder: (_) => TodoEditBar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalStateNotifier>(
      child: TodoList(
        filters: filters,
      ),
      builder: (_, localState, list) => AdaptiveScaffold(
        appBar: appBar,
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
        floatingActionButton:
            localState.selectedTodoIds.isNotEmpty ? null : _buildFab(context),
        bottomSheet: _buildBottom(context, localState.selectedTodoIds),
      ),
    );
  }
}

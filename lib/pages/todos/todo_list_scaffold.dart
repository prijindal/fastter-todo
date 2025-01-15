import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/main_drawer.dart';
import '../../models/local_state.dart';
import 'todoeditbar/index.dart';
import 'todoinputbar.dart';
import 'todolist.dart';
import 'todos_filters.dart';

class TodoListScaffold extends StatefulWidget {
  const TodoListScaffold({
    super.key,
    this.appBar,
    required this.filters,
  });

  final TodosFilters filters;

  /// An app bar to display at the top of the scaffold.
  final PreferredSizeWidget? appBar;

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

  Widget _buildList() {
    return TodoList(
      filters: widget.filters,
    );
  }

  List<Widget> _buildBottom() {
    if (_showInput) {
      return [
        Positioned(
          bottom: 0,
          right: 2,
          left: 2,
          child: TodoInputBar(
            initialProject: widget.filters.projectFilter,
            onBackButton: () {
              setState(() {
                _showInput = false;
              });
            },
          ),
        ),
      ];
    }
    final selectedEntriesEmpty =
        Provider.of<LocalStateNotifier>(context).selectedTodoIds.isEmpty;
    if (selectedEntriesEmpty) {
      return [];
    }
    return [
      Positioned(
        bottom: 0,
        right: 2,
        left: 2,
        child: TodoEditBar(),
      ),
    ];
  }

  Widget _buildBody() {
    return Stack(
      children: [_buildList(), ..._buildBottom()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      drawer: MainDrawer(),
      body: _buildBody(),
      floatingActionButton: _showInput == true ? null : _buildFab(),
    );
  }
}

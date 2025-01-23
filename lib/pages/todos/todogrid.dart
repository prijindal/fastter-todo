import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/todos_filters.dart';
import '../../helpers/todos_sorting_algoritm.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';
import 'todo_item.dart';

class TodoGrid extends StatelessWidget {
  const TodoGrid({super.key, required this.filters});

  final TodosFilters filters;

  @override
  Widget build(BuildContext context) {
    return Selector<LocalDbState,
        ({bool isTodosInitialized, List<TodoData> todos})>(
      selector: (context, state) => (
        isTodosInitialized: state.isTodosInitialized,
        todos: filters.filtered(state.todos)
          ..sort(TodosSortingAlgorithm.base().compare)
      ),
      builder: (context, state, _) => !state.isTodosInitialized
          ? Center(child: Text("Loading"))
          : _TodosGrid(
              todos: state.todos,
              filters: filters,
            ),
    );
  }
}

class _TodosGrid extends StatelessWidget {
  _TodosGrid({
    required this.todos,
    required this.filters,
  });
  final ScrollController _scrollController = ScrollController();

  final List<TodoData> todos;
  final TodosFilters filters;

  List<String> getPipelines(BuildContext context) {
    if (filters.projectFilter != null && filters.projectFilter != "inbox") {
      return Provider.of<LocalDbState>(context)
          .getProjectPipelines(filters.projectFilter);
    }
    return todos.map((todo) => todo.pipeline).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final pipelines = getPipelines(context);
    if (pipelines.isEmpty) {
      return Center(child: Text("Add some entries"));
    }
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(bottom: 60.0),
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: pipelines.length,
        // ),
        itemCount: pipelines.length,
        itemBuilder: (context, statusIndex) {
          final status = pipelines[statusIndex];
          final filteredTodos =
              todos.where((todo) => todo.pipeline == status).toList();

          final mediaQuery = MediaQuery.sizeOf(context);
          return SizedBox(
            width: min(mediaQuery.width, 600),
            child: _buildList(filteredTodos, status),
          );
        },
      ),
    );
  }

  Widget _buildPipelineChip(List<TodoData> filteredTodos, String pipeline) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Chip(
          label: Text(pipeline),
        ),
        Text(filteredTodos.length.toString()),
      ],
    );
  }

  Widget _buildList(List<TodoData> filteredTodos, String pipeline) {
    if (filteredTodos.isEmpty) {
      return Column(
        children: [
          _buildPipelineChip(filteredTodos, pipeline),
          Center(
            child: Text("No entries"),
          )
        ],
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 60.0),
      itemCount: filteredTodos.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildPipelineChip(filteredTodos, pipeline);
        }
        final todo = filteredTodos[index - 1];
        return TodoItem(
          key: Key("TodoItem${todo.id}"),
          todo: todo,
        );
      },
    );
  }
}

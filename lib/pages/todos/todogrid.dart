import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../helpers/todos_filters.dart';
import '../../helpers/todos_sorting_algoritm.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';
import '../../models/local_state.dart';
import 'todo_item.dart';
import 'todolistview.dart';

class TodoGrid extends WatchingWidget {
  const TodoGrid({super.key, required this.filters});

  final TodosFilters filters;

  @override
  Widget build(BuildContext context) {
    final isTodosInitialized =
        watchPropertyValue(((LocalDbState state) => state.isTodosInitialized));
    final todos = watchPropertyValue((LocalDbState state) =>
        filters.filtered(state.todos)
          ..sort(TodosSortingAlgorithm.base().compare));
    final width = MediaQuery.sizeOf(context).width;
    final listPerPage = (width / 400).floor();
    return !isTodosInitialized
        ? Center(child: Text("Loading"))
        : _TodosGrid(
            todos: todos,
            filters: filters,
            listPerPage: listPerPage,
          );
  }
}

class _TodosGrid extends WatchingWidget {
  _TodosGrid({
    required this.todos,
    required this.filters,
    required this.listPerPage,
  });
  final int listPerPage;
  late final PageController _pageController = PageController(
    initialPage: (listPerPage / 2).floor(),
    viewportFraction: listPerPage > 0 ? 1 / listPerPage : 1,
  );

  final List<TodoData> todos;
  final TodosFilters filters;

  List<String> getPipelines(BuildContext context) {
    if (filters.projectFilter != null && filters.projectFilter != "inbox") {
      return GetIt.I<LocalDbState>().getProjectPipelines(filters.projectFilter);
    }
    return todos.map((todo) => todo.pipeline).toSet().toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = watchPropertyValue(
        ((LocalStateNotifier state) => state.selectedTodoIds.isNotEmpty));

    final pipelines = getPipelines(context);
    if (pipelines.isEmpty) {
      return Center(child: Text("Add some entries"));
    }
    return Scrollbar(
      thumbVisibility: true,
      controller: _pageController,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: pipelines.length,
        itemBuilder: (context, statusIndex) {
          final status = pipelines[statusIndex];
          final filteredTodos =
              todos.where((todo) => todo.pipeline == status).toList();

          return _buildList(filteredTodos, status, isSelected);
        },
      ),
    );
  }

  Widget _buildPipelineChip(List<TodoData> filteredTodos, String pipeline) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Chip(
            label: Text(pipeline),
          ),
          Text(filteredTodos.length.toString()),
        ],
      ),
    );
  }

  Widget _buildList(
      List<TodoData> filteredTodos, String pipeline, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildPipelineChip(filteredTodos, pipeline),
        Flexible(
          child: TodosListView(
            dismissible: false,
            todos: filteredTodos,
            shrinkWrap: false,
            todoItemTapBehaviour: isSelected
                ? TodoItemTapBehaviour.toggleSelection
                : TodoItemTapBehaviour.openTodoBottomSheet,
            todoItemLongPressBehaviour: TodoItemTapBehaviour.toggleSelection,
            showChildren: true,
          ),
        ),
      ],
    );
  }
}

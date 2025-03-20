import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:get_it/get_it.dart';

import '../../models/core.dart';
import '../../models/local_db_state.dart';
import '../projects/index.dart';
import '../todocomments/todo_comment_item.dart';
import '../todos/todo_item.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  String _searchText = "";
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  Widget _todoTab() {
    return _SearchedList<TodoData>(
      searchText: _searchText,
      allData: GetIt.I<LocalDbState>().todos,
      getter: (todo) => todo.title.toLowerCase(),
      itemBuilder: (item) => TodoItem(
        todo: item.choice,
        tapBehaviour: TodoItemTapBehaviour.openTodoPage,
        dense: true,
        dismissible: false,
      ),
    );
  }

  Widget _projectsTab() {
    return _SearchedList<ProjectData>(
      searchText: _searchText,
      allData: GetIt.I<LocalDbState>().projects,
      getter: (project) => project.title.toString().toLowerCase(),
      itemBuilder: (item) => ProjectListTile(
        project: item.choice,
        onTap: () => AutoRouter.of(context).pushPath(
          "/todos?projectFilter=${item.choice.id}",
        ),
      ),
    );
  }

  Widget _commentsTab() {
    return _SearchedList<CommentData>(
      searchText: _searchText,
      allData: GetIt.I<LocalDbState>().comments,
      getter: (comment) => comment.content.toString().toLowerCase(),
      itemBuilder: (item) => TodoCommentItem(
        todoComment: item.choice,
        selected: false,
        onTap: () {},
        onLongPress: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (newValue) {
            setState(() {
              _searchText = newValue;
            });
          },
          decoration: InputDecoration(
            hintText: "Search",
          ),
          autofocus: true,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Todos"),
            Tab(text: "Projects"),
            Tab(text: "Comments"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _todoTab(),
          _projectsTab(),
          _commentsTab(),
        ],
      ),
    );
  }
}

class _SearchedList<T> extends StatefulWidget {
  const _SearchedList({
    super.key,
    required this.searchText,
    required this.allData,
    required this.getter,
    required this.itemBuilder,
  });

  final String searchText;
  final List<T> allData;
  final String Function(T) getter;
  final Widget Function(ExtractedResult<T>) itemBuilder;

  @override
  State<_SearchedList<T>> createState() => _SearchedListState<T>();
}

class _SearchedListState<T> extends State<_SearchedList<T>> {
  List<ExtractedResult<T>> get filtered {
    return extractAllSorted<T>(
      query: widget.searchText.toLowerCase(),
      choices: widget.allData,
      cutoff: 60,
      getter: widget.getter,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (filtered.isEmpty) {
      return Center(
        child: Text("No result found"),
      );
    }
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) => widget.itemBuilder(filtered[index]),
    );
  }
}

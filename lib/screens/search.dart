import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/store/projects.dart' as prefix0;
import 'package:fastter_dart/store/selectedtodos.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/store/todos.dart';

import '../components/hexcolor.dart';
import '../components/todoeditbar.dart';
import '../components/todoitem.dart';

import '../helpers/navigator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key key,
  }) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  String _searchText = '';
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: TextField(
            autofocus: true,
            onChanged: (newValue) {
              setState(() {
                _searchText = newValue;
              });
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            onTap: (tab) {
              _tabController.animateTo(tab);
            },
            tabs: const <Widget>[
              Tab(
                text: 'Tasks',
              ),
              Tab(
                text: 'Projects',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _SearchTodosResults(
              query: _searchText,
            ),
            _SearchProjectsResults(
              query: _searchText,
            )
          ],
        ),
      );
}

class _SearchTodosResults extends StatelessWidget {
  const _SearchTodosResults({
    @required this.query,
  });
  final String query;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterEvent<Todo>, ListState<Todo>>(
        bloc: fastterTodos,
        builder: (context, state) => _SearchTodosResultsComponent(
              todos: state.copyWith(
                items: state.items
                    .where((todo) =>
                        fastterTodos.filterObject(todo, <String, dynamic>{
                          'query': query,
                        }))
                    .toList()
                      ..sort(getCompareFunction(state.sortBy)),
              ),
            ),
      );
}

class _SearchTodosResultsComponent extends StatelessWidget {
  const _SearchTodosResultsComponent({
    @required this.todos,
  });

  final ListState<Todo> todos;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          ListView.builder(
            itemCount: todos.items.length,
            itemBuilder: (context, index) => TodoItem(
                  todo: todos.items[index],
                ),
          ),
          Positioned(
            bottom: 0,
            right: 2,
            left: 2,
            child: BlocBuilder<SelectedTodoEvent, List<String>>(
              bloc: selectedTodosBloc,
              builder: (context, selectedTodos) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) =>
                        SizeTransition(child: child, sizeFactor: animation),
                    child:
                        selectedTodos.isNotEmpty ? TodoEditBar() : Container(),
                  ),
            ),
          ),
        ],
      );
}

class _SearchProjectsResults extends StatelessWidget {
  const _SearchProjectsResults({
    @required this.query,
  });
  final String query;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterEvent<Project>, ListState<Project>>(
        bloc: prefix0.fastterProjects,
        builder: (context, state) => _SearchProjectsResultsComponent(
              projects: state.items,
            ),
      );
}

class _SearchProjectsResultsComponent extends StatelessWidget {
  const _SearchProjectsResultsComponent({
    @required this.projects,
  });

  final List<Project> projects;

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/todos',
                    arguments: {'project': projects[index]});
                history.add(RouteInfo('/todos',
                    arguments: {'project': projects[index]}));
              },
              leading: Icon(
                Icons.group_work,
                color: projects[index].color == null
                    ? null
                    : HexColor(projects[index].color),
              ),
              title: Text(projects[index].title),
            ),
      );
}

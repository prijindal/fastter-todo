import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'home_app_bar.dart';
import 'todo_list_scaffold.dart';

const mediaBreakpoint = 700;

@RoutePage()
class TodosScreen extends StatelessWidget {
  const TodosScreen({
    super.key,
    @queryParam this.projectFilter,
    @queryParam this.tagFilter,
    @queryParam this.daysAhead,
    @queryParam this.title = "Todos",
  });

  final String? projectFilter;
  final String? tagFilter;
  final int? daysAhead; // Due Date less than or equal to
  final String title;

  @override
  Widget build(BuildContext context) {
    return TodoListScaffold(
      appBar: HomeAppBar(
        title: title,
      ),
      projectFilter: projectFilter,
      tagFilter: tagFilter,
      daysAhead: daysAhead,
    );
  }
}

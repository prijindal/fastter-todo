import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../home/home_app_bar.dart';
import '../home/todo_list_scaffold.dart';

@RoutePage()
class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key, @PathParam() required this.projectFilter});

  final String projectFilter;

  @override
  Widget build(BuildContext context) {
    return TodoListScaffold(
      appBar: const HomeAppBar(),
      projectFilter: projectFilter,
    );
  }
}

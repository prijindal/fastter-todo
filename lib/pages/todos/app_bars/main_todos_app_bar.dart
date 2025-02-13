import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../../helpers/todos_filters.dart';
import '../../../models/local_db_state.dart';
import 'app_bar_with_actions.dart';

class MainTodosAppBar extends WatchingWidget {
  const MainTodosAppBar({super.key, required this.filters});

  final TodosFilters filters;

  @override
  Widget build(BuildContext context) {
    final actions = filters.actions;
    final primaryAction = actions.first;
    final secondaryActions = actions.sublist(1);
    final projects = watchPropertyValue((LocalDbState state) => state.projects);
    return AppBarWithActions(
      title: filters.createTitle(projects),
      primaryAction: primaryAction,
      secondaryActions: secondaryActions,
    );
  }
}

import 'package:flutter/material.dart';

import '../../../helpers/todos_filters.dart';
import 'app_bar_with_actions.dart';

class MainTodosAppBar extends StatelessWidget {
  const MainTodosAppBar({super.key, required this.filters});

  final TodosFilters filters;

  @override
  Widget build(BuildContext context) {
    final actions = filters.actions;
    final primaryAction = actions.first;
    final secondaryActions = actions.sublist(1);
    return AppBarWithActions(
      title: filters.createTitle,
      primaryAction: primaryAction,
      secondaryActions: secondaryActions,
    );
  }
}

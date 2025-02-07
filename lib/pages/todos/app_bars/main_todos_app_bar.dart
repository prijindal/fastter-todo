import 'package:flutter/material.dart';

import '../../../helpers/todos_filters.dart';

class MainTodosAppBar extends StatelessWidget {
  const MainTodosAppBar({super.key, required this.filters});

  final TodosFilters filters;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(filters.createTitle),
      actions: filters.actions
          .map(
            (action) => IconButton(
              onPressed: () => action.onPressed(context),
              icon: action.icon,
            ),
          )
          .toList(),
    );
  }
}

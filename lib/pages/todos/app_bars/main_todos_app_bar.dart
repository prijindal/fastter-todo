import 'package:flutter/material.dart';

import '../../../helpers/todos_filters.dart';

class MainTodosAppBar extends StatelessWidget {
  const MainTodosAppBar({super.key, required this.filters});

  final TodosFilters filters;

  Widget _buildTitle(BuildContext context) {
    return Text(filters.createTitle(context));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildTitle(context),
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

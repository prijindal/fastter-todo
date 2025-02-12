import 'package:flutter/material.dart';

class AppBarAction {
  const AppBarAction({
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  final Icon icon;
  final String title;
  final void Function(BuildContext context) onPressed;
}

class AppBarWithActions extends StatelessWidget {
  const AppBarWithActions({
    super.key,
    required this.title,
    required this.primaryAction,
    required this.secondaryActions,
  });

  final String title;
  final AppBarAction primaryAction;
  final List<AppBarAction> secondaryActions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          onPressed: () => primaryAction.onPressed(context),
          icon: primaryAction.icon,
          tooltip: primaryAction.title,
        ),
        PopupMenuButton<void Function(BuildContext)>(
          itemBuilder: (context) => secondaryActions
              .map(
                (secondaryAction) => PopupMenuItem<void Function(BuildContext)>(
                  value: secondaryAction.onPressed,
                  child: Text(secondaryAction.title),
                ),
              )
              .toList(),
          onSelected: (action) => action(context),
        ),
      ],
    );
  }
}

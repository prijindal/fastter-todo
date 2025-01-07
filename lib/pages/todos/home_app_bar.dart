import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/local_state.dart';
import 'todoeditbar/delete_selected_todos_button.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Selector<LocalStateNotifier, bool>(
      builder: (context, selectedEntriesEmpty, _) => selectedEntriesEmpty
          ? MainAppBar(
              title: title,
            )
          : const SelectedEntriesAppBar(),
      selector: (_, localState) => localState.selectedTodoIds.isEmpty,
    );
  }
}

class MainAppBar extends StatelessWidget {
  const MainAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          onPressed: () {
            AutoRouter.of(context).pushNamed("/settings");
          },
          icon: const Icon(
            Icons.settings,
            size: 26.0,
          ),
        ),
      ],
    );
  }
}

class SelectedEntriesAppBar extends StatelessWidget {
  const SelectedEntriesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localStateNotifier = Provider.of<LocalStateNotifier>(context);
    return AppBar(
      leading: IconButton(
        onPressed: () {
          localStateNotifier.setSelectedTodoIds([]);
        },
        icon: Icon(Icons.arrow_back),
      ),
      title: Text("${localStateNotifier.selectedTodoIds.length} Selected"),
      actions: [
        DeleteSelectedTodosButton(),
      ],
    );
  }
}

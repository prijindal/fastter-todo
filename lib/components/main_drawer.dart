import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:watch_it/watch_it.dart';

import '../helpers/todos_filters.dart';
import '../models/local_db_state.dart';
import '../router/app_router.dart';

class NavigationListTile extends StatelessWidget {
  const NavigationListTile({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.route,
    this.trailing,
  });

  final String label;
  final Icon icon;
  final Icon selectedIcon;
  final String? route;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    AppRouter appRouter = GetIt.I<AppRouter>();
    final selected = appRouter.currentUrl == route;
    return ListTile(
      title: Text(label),
      selected: selected,
      leading: selected ? selectedIcon : icon,
      trailing: trailing == null ? null : Text(trailing!),
      onTap: route == null
          ? null
          : () async {
              await appRouter.navigateNamed(route!);
              if (context.mounted && Scaffold.of(context).isDrawerOpen) {
                Scaffold.of(context).closeDrawer();
              }
            },
    );
  }
}

// List tile to specifically navigate to todos page
class TodosNavigationListTile extends WatchingWidget {
  const TodosNavigationListTile({
    super.key,
    required this.filters,
    required this.icon,
    required this.selectedIcon,
  });

  final TodosFilters filters;
  final Icon icon;
  final Icon selectedIcon;

  @override
  Widget build(BuildContext context) {
    final filtered = watchPropertyValue(
        (LocalDbState state) => filters.filtered(state.todos));
    final completed = filtered.where((a) => a.completed).length;
    final total = filtered.length;
    final queryString = filters.queryString;
    return NavigationListTile(
      icon: icon,
      selectedIcon: selectedIcon,
      route: queryString.isEmpty ? "/todos" : "/todos?$queryString",
      label: filters.createTitle,
      trailing: "$completed/$total",
    );
  }
}

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          TodosNavigationListTile(
            filters: TodosFilters(projectFilter: "inbox"),
            icon: Icon(Icons.inbox_outlined),
            selectedIcon: Icon(Icons.inbox),
          ),
          TodosNavigationListTile(
            filters: TodosFilters(),
            icon: Icon(Icons.select_all_outlined),
            selectedIcon: Icon(Icons.select_all),
          ),
          TodosNavigationListTile(
            filters: TodosFilters(daysAhead: 1),
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
          ),
          TodosNavigationListTile(
            filters: TodosFilters(daysAhead: 7),
            icon: Icon(Icons.calendar_view_day_outlined),
            selectedIcon: Icon(Icons.calendar_view_day),
          ),
          ProjectExpansionTile(),
          TagsExpansionTile(),
          NavigationListTile(
            route: "/settings",
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

class ProjectExpansionTile extends WatchingWidget {
  const ProjectExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = watchPropertyValue((LocalDbState state) => state.projects);
    final children = <Widget>[];
    if (projects.isNotEmpty) {
      children.addAll(projects
          .map(
            (project) => TodosNavigationListTile(
              filters: TodosFilters(projectFilter: project.id),
              icon: Icon(
                Icons.group_work_outlined,
                color: HexColor(project.color),
              ),
              selectedIcon: Icon(
                Icons.group_work,
                color: HexColor(project.color),
              ),
            ),
          )
          .toList());
    }
    children.add(
      NavigationListTile(
        label: "Manage projects",
        icon: Icon(Icons.group_work_outlined),
        selectedIcon: Icon(Icons.group_work),
        route: "/projects",
      ),
    );
    children.add(
      NavigationListTile(
        label: "Add Project",
        icon: Icon(Icons.add_outlined),
        selectedIcon: Icon(Icons.add),
        route: "/newproject",
      ),
    );
    // TODO: Make this better
    // trailing icons should show both down arrow and add
    return ExpansionTile(
      initiallyExpanded: true,
      leading: Icon(Icons.group_work_outlined),
      title: Text("Projects"),
      children: children,
    );
  }
}

class TagsExpansionTile extends WatchingWidget {
  const TagsExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = watchPropertyValue((LocalDbState state) => state.allTags);
    final children = <Widget>[];
    if (tags.isNotEmpty) {
      children.addAll(tags
          .map(
            (tag) => TodosNavigationListTile(
              filters: TodosFilters(tagFilter: tag),
              icon: Icon(
                Icons.tag_outlined,
              ),
              selectedIcon: Icon(
                Icons.tag,
              ),
            ),
          )
          .toList());
    }
    // TODO: Make this better
    // trailing icons should show both down arrow and add
    return ExpansionTile(
      initiallyExpanded: true,
      leading: Icon(Icons.tag),
      title: Text("Tags"),
      children: children,
    );
  }
}

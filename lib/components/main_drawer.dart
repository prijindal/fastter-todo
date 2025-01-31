import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../helpers/todos_filters.dart';
import '../models/core.dart';
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
class TodosNavigationListTile extends StatelessWidget {
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
    return Selector<LocalDbState,
        ({int completed, int total, String queryString})>(
      selector: (_, state) {
        final filtered = filters.filtered(state.todos);
        return (
          completed: filtered.where((a) => a.completed).length,
          total: filtered.length,
          queryString: filters.queryString,
        );
      },
      builder: (context, todos, _) => NavigationListTile(
        icon: icon,
        selectedIcon: selectedIcon,
        route: todos.queryString.isEmpty
            ? "/todos"
            : "/todos?${todos.queryString}",
        label: filters.createTitle(context),
        trailing: "${todos.completed}/${todos.total}",
      ),
    );
  }
}

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  Widget _buildProjectsDestination(
      BuildContext context, List<ProjectData>? projects) {
    final children = <Widget>[];
    if (projects != null) {
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

  Widget _buildTagsDestination(BuildContext context, List<String>? tags) {
    final children = <Widget>[];
    if (tags != null) {
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
          Selector<LocalDbState, List<ProjectData>>(
            selector: (_, state) => state.projects,
            builder: (context, projects, _) {
              return _buildProjectsDestination(context, projects);
            },
          ),
          Selector<LocalDbState, List<String>>(
            selector: (_, state) => state.allTags,
            builder: (context, tags, _) {
              return _buildTagsDestination(context, tags);
            },
          ),
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

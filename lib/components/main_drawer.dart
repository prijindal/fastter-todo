import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../models/core.dart';
import '../models/drift.dart';

class NavigationListTile extends StatelessWidget {
  const NavigationListTile({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.route,
  });

  final String label;
  final Icon icon;
  final Icon selectedIcon;
  final String? route;

  @override
  Widget build(BuildContext context) {
    final autoRouter = AutoRouter.of(context);
    final selected = autoRouter.currentPath == route;
    return ListTile(
      title: Text(label),
      selected: selected,
      leading: selected ? selectedIcon : icon,
      onTap: route == null ? null : () => autoRouter.replaceNamed(route!),
    );
  }
}

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  Widget _buildProjectsDestination(
      BuildContext context, List<ProjectData>? projects) {
    final children = <NavigationListTile>[];
    if (projects != null) {
      children.addAll(projects
          .map(
            (project) => NavigationListTile(
              route: "/project/${project.id}",
              icon: Icon(
                Icons.group_work_outlined,
                color: HexColor(project.color),
              ),
              selectedIcon: Icon(
                Icons.group_work,
                color: HexColor(project.color),
              ),
              label: project.title,
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          NavigationListTile(
            route: "/project/inbox",
            icon: Icon(Icons.inbox_outlined),
            selectedIcon: Icon(Icons.inbox),
            label: "Inbox",
          ),
          NavigationListTile(
            route: "/todos",
            icon: Icon(Icons.select_all_outlined),
            selectedIcon: Icon(Icons.select_all),
            label: "All tasks",
          ),
          NavigationListTile(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: "Today",
          ),
          NavigationListTile(
            icon: Icon(Icons.calendar_view_day_outlined),
            selectedIcon: Icon(Icons.calendar_view_day),
            label: "7 Days",
          ),
          StreamBuilder<List<ProjectData>>(
            stream: MyDatabase.instance.managers.project.watch(),
            builder: (context, projectsSnapshot) {
              return _buildProjectsDestination(context, projectsSnapshot.data);
            },
          ),
        ],
      ),
    );
  }
}

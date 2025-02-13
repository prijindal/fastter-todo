import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../helpers/todos_filters.dart';
import '../../models/local_db_state.dart';
import '../../models/settings.dart';

@RoutePage()
class StylingSettingsScreen extends StatelessWidget {
  const StylingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings -> Styling"),
      ),
      body: ListView(children: [
        const ListTile(
          title: Text("Customize"),
          dense: true,
        ),
        const ThemeSelectorTile(),
        const ColorSeedSelectorTile(),
        const DefaultRouteSelectorTile(),
      ]),
    );
  }
}

class ThemeSelectorTile extends WatchingWidget {
  const ThemeSelectorTile({super.key});

  String themeDataToText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return "System";
      case ThemeMode.dark:
        return "Dark";
      case ThemeMode.light:
        return "Light";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text("Select a Theme Mode"),
      title: DropdownButton<ThemeMode>(
        value: watchPropertyValue((SettingsStorageNotifier s) => s.getTheme()),
        items: ThemeMode.values
            .map(
              (e) => DropdownMenuItem<ThemeMode>(
                value: e,
                child: Text(themeDataToText(e)),
              ),
            )
            .toList(),
        onChanged: (newValue) async {
          await GetIt.I<SettingsStorageNotifier>()
              .setTheme(newValue ?? ThemeMode.system);
        },
      ),
    );
  }
}

class ColorSeedSelectorTile extends WatchingWidget {
  const ColorSeedSelectorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text("Select a Color"),
      title: DropdownButton<ColorSeed>(
        value:
            watchPropertyValue((SettingsStorageNotifier s) => s.getBaseColor()),
        items: ColorSeed.values
            .map(
              (e) => DropdownMenuItem<ColorSeed>(
                value: e,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        right: 10,
                        top: 5.0,
                      ),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: e.color),
                    ),
                    Text(e.label),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (newValue) async {
          await GetIt.I<SettingsStorageNotifier>()
              .setColor(newValue ?? ColorSeed.baseColor);
        },
      ),
    );
  }
}

class DefaultRouteSelectorTile extends WatchingWidget {
  const DefaultRouteSelectorTile({super.key});

  List<TodosFilters> _getAllFilters() {
    final staticFilters = [
      TodosFilters(),
      TodosFilters(projectFilter: "inbox"),
      TodosFilters(daysAhead: 1),
      TodosFilters(daysAhead: 7),
    ];
    final projects = GetIt.I<LocalDbState>()
        .projects
        .map((project) => TodosFilters(projectFilter: project.id));
    return [...staticFilters, ...projects];
  }

  @override
  Widget build(BuildContext context) {
    final projects = watchPropertyValue((LocalDbState state) => state.projects);
    return ListTile(
      subtitle: Text("Select Default route"),
      title: DropdownButton<TodosFilters>(
        value: watchPropertyValue((SettingsStorageNotifier s) =>
            _getAllFilters()
                .singleWhere((a) => a.queryString == s.getDefaultRoute())),
        items: _getAllFilters()
            .map(
              (e) => DropdownMenuItem<TodosFilters>(
                value: e,
                child: Text(e.createTitle(projects)),
              ),
            )
            .toList(),
        onChanged: (newValue) async {
          await GetIt.I<SettingsStorageNotifier>()
              .setDefaultRoute(newValue?.queryString ?? "");
        },
      ),
    );
  }
}

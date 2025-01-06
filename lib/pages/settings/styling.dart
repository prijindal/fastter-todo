import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      ]),
    );
  }
}

class ThemeSelectorTile extends StatelessWidget {
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
    return Consumer<SettingsStorageNotifier>(
      builder: (context, settingsStorage, _) => ListTile(
        subtitle: Text("Select a Theme Mode"),
        title: DropdownButton<ThemeMode>(
          value: settingsStorage.getTheme(),
          items: ThemeMode.values
              .map(
                (e) => DropdownMenuItem<ThemeMode>(
                  value: e,
                  child: Text(themeDataToText(e)),
                ),
              )
              .toList(),
          onChanged: (newValue) async {
            await settingsStorage.setTheme(newValue ?? ThemeMode.system);
          },
        ),
      ),
    );
  }
}

class ColorSeedSelectorTile extends StatelessWidget {
  const ColorSeedSelectorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsStorageNotifier>(
      builder: (context, settingsStorage, _) => ListTile(
        subtitle: Text("Select a Color"),
        title: DropdownButton<ColorSeed>(
          value: settingsStorage.getBaseColor(),
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
            await settingsStorage.setColor(newValue ?? ColorSeed.baseColor);
          },
        ),
      ),
    );
  }
}

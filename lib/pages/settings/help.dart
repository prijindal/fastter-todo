import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

@RoutePage()
class HelpSettingsScreen extends StatefulWidget {
  const HelpSettingsScreen({super.key});

  @override
  State<HelpSettingsScreen> createState() => _HelpSettingsScreenState();
}

class _HelpSettingsScreenState extends State<HelpSettingsScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: "Fastter Todo",
    packageName: "com.prijindal.fastter_todo",
    version: "1.0.0",
    buildNumber: "1",
  );
  final Widget applicationIcon = Image.asset(
    'assets/icon/ic_launcher.png',
    width: 48,
  );

  @override
  void initState() {
    _readPackageInfo();
    super.initState();
  }

  Future<void> _readPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = packageInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings -> Help"),
      ),
      body: ListView(children: [
        const ListTile(
          title: Text("App Info"),
          dense: true,
        ),
        ListTile(
          leading: applicationIcon,
          title: Text(_packageInfo.appName),
          subtitle: Text(_packageInfo.version),
        ),
        ListTile(
          title: const Text('Licenses'),
          onTap: () => showLicensePage(
            context: context,
            applicationName: _packageInfo.appName,
            applicationVersion: _packageInfo.version,
            applicationLegalese: "Made by Priyanshu Jindal",
            applicationIcon: applicationIcon,
          ),
        ),
        ListTile(
          title: const Text('Privacy Policy'),
          onTap: () => launchUrlString(
              'https://fastter-todo-prijindal.web.app/privacy-policy.html'),
        ),
        ListTile(
            title: const Text('Source Code'),
            subtitle: const Text('https://github.com/prijindal/fastter-todo'),
            onTap: () => launchUrlString(
                  'https://github.com/prijindal/fastter-todo',
                )),
        const ListTile(
          title: Text("Developer Info"),
          dense: true,
        ),
        ListTile(
          leading: Image.asset(
            'assets/icon/prijindal.png',
            width: 48,
          ),
          title: Text("Priyanshu Jindal"),
          onTap: () => launchUrlString("https://github.com/prijindal"),
        ),
      ]),
    );
  }
}

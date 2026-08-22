import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/fileio.dart';

@RoutePage()
class BackupSettingsScreen extends StatelessWidget {
  const BackupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings -> Backup"),
      ),
      body: ListView(children: [
        const ListTile(
          title: Text("Local Backup"),
          dense: true,
        ),
        ListTile(
          title: const Text("Download as JSON"),
          onTap: () => downloadContent(context),
        ),
        ListTile(
          title: const Text("Upload from file"),
          onTap: () => uploadContent(context),
        ),
      ]),
    );
  }
}

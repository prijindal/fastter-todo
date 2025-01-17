import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../components/adaptive_scaffold.dart';

enum RequiredPermissions {
  notification(
    permission: Permission.notification,
    title: "Notifications",
    description: "Required to display reminders",
  ),
  scheduleExactAlarm(
    permission: Permission.scheduleExactAlarm,
    title: "Schedule Exact Alarm",
    description: "Required to schedule exact reminders",
  ),
  batteryOptimizations(
    permission: Permission.ignoreBatteryOptimizations,
    title: "Ignore Battery Optimization",
    description: "Required to schedule exact reminders",
  ),
  ;

  final Permission permission;
  final String title;
  final String description;

  const RequiredPermissions({
    required this.permission,
    required this.title,
    required this.description,
  });
}

@RoutePage()
class PermissionsSettingsScreen extends StatefulWidget {
  const PermissionsSettingsScreen({super.key});

  @override
  State<PermissionsSettingsScreen> createState() =>
      _PermissionsSettingsScreenState();
}

class _PermissionsSettingsScreenState extends State<PermissionsSettingsScreen> {
  final Map<RequiredPermissions, PermissionStatus?> _permissions = {
    RequiredPermissions.notification: null,
    RequiredPermissions.scheduleExactAlarm: null,
    RequiredPermissions.batteryOptimizations: null,
  };

  @override
  void initState() {
    // TODO: implement initState
    _loadPermissions();
    super.initState();
  }

  Future<void> _loadPermissions() async {
    await Future.wait(
        _permissions.keys.map((a) => a.permission.status.then((status) {
              setState(() {
                _permissions[a] = status;
              });
            })));
  }

  Widget _buildPermissionTile(RequiredPermissions requiredPermission) {
    final status = _permissions[requiredPermission];
    return ListTile(
      title: Text(requiredPermission.title),
      subtitle: status == null ? null : Text(status.name),
      onTap: status == PermissionStatus.granted
          ? null
          : () async {
              if (status == PermissionStatus.granted) {
                return;
              }
              requiredPermission.permission.request().then((value) {
                setState(() {
                  _permissions[requiredPermission] = value;
                });
              });
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        title: const Text("Settings -> Permissions"),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text("Permissions"),
            dense: true,
          ),
          ...(_permissions.keys.map(_buildPermissionTile).toList())
        ],
      ),
    );
  }
}

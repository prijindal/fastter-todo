import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../../helpers/logger.dart';
import '../../models/settings.dart';
import 'components/backup_encryption_tile.dart';
import 'components/pin_lock.dart';

@RoutePage()
class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings -> Security"),
      ),
      body: ListView(children: [
        const ListTile(
          title: Text("Hidden Entries"),
          dense: true,
        ),
        const LockHiddenSettingsTile(),
        const ListTile(
          title: Text("Backup Encryption"),
          dense: true,
        ),
        const BackupEncryptionTile(),
      ]),
    );
  }
}

class LockHiddenSettingsTile extends StatefulWidget {
  const LockHiddenSettingsTile({super.key});

  @override
  State<LockHiddenSettingsTile> createState() => _LockHiddenSettingsTileState();
}

class _LockHiddenSettingsTileState extends State<LockHiddenSettingsTile> {
  List<HiddenLockedMode> _availableModes = [
    HiddenLockedMode.none,
    HiddenLockedMode.pin
  ];

  @override
  initState() {
    _checkLocalAuth();
    super.initState();
  }

  void _checkLocalAuth() async {
    if (!kIsWeb) {
      final LocalAuthentication auth = LocalAuthentication();
      final canCheckBiometrics = await auth.isDeviceSupported();
      if (canCheckBiometrics) {
        final availableBiometrics = await auth.getAvailableBiometrics();
        if (availableBiometrics.isEmpty) {
          AppLogger.instance.d("Biometrics not enabled on this device");
        } else {
          AppLogger.instance.d(availableBiometrics);
          setState(() {
            _availableModes = [
              HiddenLockedMode.none,
              HiddenLockedMode.pin,
              HiddenLockedMode.biometrics
            ];
          });
        }
      } else {
        AppLogger.instance.d("Biometrics not supported on this device");
      }
    }
  }

  Future<bool> _verifyLocalAuth() async {
    final LocalAuthentication auth = LocalAuthentication();

    final authenticated = await auth.authenticate(
      localizedReason: "Biometrics scan for hiding entries",
      options: AuthenticationOptions(
        biometricOnly: true,
      ),
    );
    if (!authenticated) {
      AppLogger.instance
          .i("Biometrics authenticated failed, not changing values");
      return false;
    } else {
      AppLogger.instance.d(
          "Biometrics authenticated successful, enabling biometrics authentication");
      return true;
    }
  }

  Widget _buildTitle() {
    if (_availableModes.length <= 1) {
      return Text("Locking not available");
    }
    final settingsStorage = Provider.of<SettingsStorageNotifier>(context);
    final currentLockedMode = settingsStorage.getHiddenLockedMode();
    return DropdownButton<HiddenLockedMode>(
      value: currentLockedMode,
      items: _availableModes
          .map(
            (e) => DropdownMenuItem<HiddenLockedMode>(
              value: e,
              child: Text(e.label),
            ),
          )
          .toList(),
      onChanged: (newValue) async {
        if (currentLockedMode == HiddenLockedMode.pin) {
          final successAuth = await PinLockScreen.verifyPin(context);
          if (!successAuth) {
            return;
          }
        }
        if (newValue == HiddenLockedMode.biometrics ||
            currentLockedMode == HiddenLockedMode.biometrics) {
          // If new value or existing value is biometrics, authenticate using biometrics first
          final successAuth = await _verifyLocalAuth();
          if (!successAuth) {
            return;
          }
        }
        if (newValue == HiddenLockedMode.pin) {
          // ignore: use_build_context_synchronously
          final successAuth = await PinLockScreen.createNewPin(context);
          if (!successAuth) {
            return;
          }
        }
        await settingsStorage
            .setHiddenLockedMode(newValue ?? HiddenLockedMode.none);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text("Select Locking method for hidden entries"),
      title: _buildTitle(),
    );
  }
}

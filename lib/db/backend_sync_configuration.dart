import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

final backendSyncSettingsKey = "backendSyncSettings";

Future<void> urlLauncher(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

class BackendSyncConfiguration {
  String syncUrl;
  String authToken;
  int syncIntervalSeconds;

  BackendSyncConfiguration({
    required this.syncUrl,
    required this.authToken,
    required this.syncIntervalSeconds,
  });

  static BackendSyncConfiguration? fromJson(Map<String, dynamic> json) {
    if (json.containsKey("syncUrl") &&
        json.containsKey("authToken") &&
        json.containsKey("syncIntervalSeconds")) {
      return BackendSyncConfiguration(
        syncUrl: json["syncUrl"] as String,
        authToken: json["authToken"] as String,
        syncIntervalSeconds: json["syncIntervalSeconds"] as int,
      );
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "syncUrl": syncUrl,
      "authToken": authToken,
      "syncIntervalSeconds": syncIntervalSeconds,
    };
  }
}

class BackendSyncConfigurationService extends ChangeNotifier {
  BackendSyncConfiguration? _backendSyncConfiguration;

  BackendSyncConfigurationService(this._backendSyncConfiguration);

  BackendSyncConfiguration? get backendSyncConfiguration =>
      _backendSyncConfiguration;

  static Future<BackendSyncConfiguration?> load() async {
    final backendSyncSettings =
        await SharedPreferencesAsync().getString(backendSyncSettingsKey);
    if (backendSyncSettings == null) {
      return null;
    } else {
      final config = BackendSyncConfiguration.fromJson(
          jsonDecode(backendSyncSettings) as Map<String, dynamic>);
      return config;
    }
  }

  static Future<BackendSyncConfigurationService> init() async {
    return BackendSyncConfigurationService(
        await BackendSyncConfigurationService.load());
  }

  static Future<BackendSyncConfiguration> newBackend({
    required String syncUrl,
    required String authToken,
    required int syncIntervalSeconds,
  }) async {
    // TODO: Validate sync url and auth token

    return BackendSyncConfiguration(
      syncUrl: syncUrl,
      authToken: authToken,
      syncIntervalSeconds: syncIntervalSeconds,
    );
  }

  Future<void> setRemote(BackendSyncConfiguration config) async {
    _backendSyncConfiguration = config;
    // TODO: Check if remote is valid by doing a health check
    await SharedPreferencesAsync().setString(
      backendSyncSettingsKey,
      jsonEncode(_backendSyncConfiguration!.toJson()),
    );
    notifyListeners();
  }

  Future<void> clearRemote() async {
    _backendSyncConfiguration = null;
    await SharedPreferencesAsync().remove(backendSyncSettingsKey);
    notifyListeners();
  }
}

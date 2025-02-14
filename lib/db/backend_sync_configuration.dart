import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/logger.dart';

final backendSyncSettingsKey = "backendSyncSettings";

class BackendSyncConfiguration {
  String url;
  String jwtToken;

  BackendSyncConfiguration({required this.url, required this.jwtToken});

  static BackendSyncConfiguration fromJson(Map<String, dynamic> json) {
    return BackendSyncConfiguration(
      url: json["url"] as String,
      jwtToken: json["jwtToken"] as String,
    );
  }

  Map<String, String> toJson() {
    return {
      "url": url,
      "jwtToken": jwtToken,
    };
  }
}

class BackendSyncConfigurationService extends ChangeNotifier {
  BackendSyncConfiguration? _backendSyncConfiguration;

  BackendSyncConfigurationService(this._backendSyncConfiguration);

  BackendSyncConfiguration? get backendSyncConfiguration =>
      _backendSyncConfiguration;

  static Future<BackendSyncConfigurationService> init() async {
    final backendSyncSettings =
        await SharedPreferencesAsync().getString(backendSyncSettingsKey);
    if (backendSyncSettings == null) {
      return BackendSyncConfigurationService(null);
    } else {
      final config = BackendSyncConfiguration.fromJson(
          jsonDecode(backendSyncSettings) as Map<String, dynamic>);
      return BackendSyncConfigurationService(config);
    }
  }

  static Future<void> checkConnection(BackendSyncConfiguration config) async {
    final uri = Uri.parse(config.url).replace(path: "/auth/user");
    AppLogger.instance.i("Checking connection to ${uri.host}");
    final health = await http
        .get(uri, headers: {"Authorization": "Bearer ${config.jwtToken}"});
    if (health.statusCode != 200) {
      throw Error();
    }
    final response = jsonDecode(health.body);
    final id = response["id"] as String?;
    AppLogger.instance.i("Connection to ${uri.host} is successful. ID: $id");
  }

  Future<void> setRemote(BackendSyncConfiguration config) async {
    await checkConnection(config);
    _backendSyncConfiguration = config;
    // TODO: Check if remote is valid by doing a health check
    await SharedPreferencesAsync().setString(
      backendSyncSettingsKey,
      jsonEncode(config.toJson()),
    );
    notifyListeners();
  }

  Future<void> clearRemote() async {
    _backendSyncConfiguration = null;
    await SharedPreferencesAsync().remove(backendSyncSettingsKey);
    notifyListeners();
  }
}

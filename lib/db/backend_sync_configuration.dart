import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../grpc_client/api_from_server.dart';
import '../helpers/logger.dart';
import '../schemaless_proto/google/protobuf/empty.pb.dart';
import '../schemaless_proto/types/login.pb.dart';

final backendSyncSettingsKey = "backendSyncSettings";

class BackendSyncConfiguration {
  String url;
  String jwtToken;
  bool tls = false;
  bool allowInsecure = false;

  BackendSyncConfiguration({
    required this.url,
    required this.jwtToken,
    this.tls = false,
    this.allowInsecure = false,
  });

  static BackendSyncConfiguration fromJson(Map<String, dynamic> json) {
    return BackendSyncConfiguration(
      url: json["url"] as String,
      jwtToken: json["jwtToken"] as String,
      tls: json["tls"] as bool,
      allowInsecure: json["allowInsecure"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "jwtToken": jwtToken,
      "tls": tls,
      "allowInsecure": allowInsecure,
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

  static Future<String> register({
    required String url,
    required bool tls,
    required bool allowInsecure,
    required String email,
    required String password,
  }) async {
    final loginApi = getLoginApiFromUrl(
      url,
      tls: tls,
      allowInsecure: allowInsecure,
    );
    await loginApi.registerUser(LoginRequest(
      email: email,
      password: password,
    ));
    return login(
      url: url,
      tls: tls,
      allowInsecure: allowInsecure,
      email: email,
      password: password,
    );
  }

  static Future<String> login({
    required String url,
    required bool tls,
    required bool allowInsecure,
    required String email,
    required String password,
  }) async {
    final loginApi = getLoginApiFromUrl(
      url,
      tls: tls,
      allowInsecure: allowInsecure,
    );
    final loginResponse = await loginApi.loginUser(LoginRequest(
      email: email,
      password: password,
    ));
    AppLogger.instance
        .i("Connection to $url is successful. ID: ${loginResponse.iD}");
    final api = ApiFromServerInfo(
      url: url,
      jwtToken: loginResponse.token,
      tls: tls,
      allowInsecure: allowInsecure,
    );
    final res = await api.authClient.generateKey(Empty());
    AppLogger.instance
        .i("Generating token on $url is successful. ID: ${loginResponse.iD}");
    return res.token;
  }

  Future<void> setRemote({
    required String url,
    required bool tls,
    required bool allowInsecure,
    required String token,
  }) async {
    _backendSyncConfiguration = BackendSyncConfiguration(
      url: url,
      jwtToken: token,
      tls: tls,
      allowInsecure: allowInsecure,
    );
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

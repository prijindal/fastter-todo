import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openid_client/openid_client.dart' as openid;
import 'package:openid_client/openid_client_io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../grpc_client/api_from_server.dart';
import '../schemaless_proto/types/v1/openid.pb.dart';

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
  String url;
  String clientId;
  String accessToken;
  String refreshToken;
  String tokenEndpoint;
  DateTime expiresAt;
  bool tls = false;
  bool allowInsecure = false;

  BackendSyncConfiguration({
    required this.url,
    required this.clientId,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenEndpoint,
    required this.expiresAt,
    this.tls = false,
    this.allowInsecure = false,
  });

  static BackendSyncConfiguration fromJson(Map<String, dynamic> json) {
    return BackendSyncConfiguration(
      url: json["url"] as String,
      clientId: json["clientId"] as String,
      accessToken: json["accessToken"] as String,
      refreshToken: json["refreshToken"] as String,
      tokenEndpoint: json["tokenEndpoint"] as String,
      expiresAt: DateTime.parse(json["expiresAt"] as String),
      tls: json["tls"] as bool,
      allowInsecure: json["allowInsecure"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "clientId": clientId,
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "tokenEndpoint": tokenEndpoint,
      "expiresAt": expiresAt.toIso8601String(),
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

  static Future<BackendSyncConfiguration> login({
    required String url,
    required bool tls,
    required bool allowInsecure,
    required String clientId,
  }) async {
    final configApi = getConfigApiFromUrl(url);

    final openIdConfiguration = await configApi.getOpenIdConfiguration(
      GetOpenIdConfigurationRequest(),
    );

    var issuer = await openid.Issuer.discover(
      Uri.parse((openIdConfiguration.issuer)),
    );
    final tokenEndpoint = openIdConfiguration.tokenEndpoint;
    var client = openid.Client(issuer, clientId);

    var authenticator = Authenticator(
      client,
      port: 4000,
      urlLancher: urlLauncher,
    );

    var c = await authenticator.authorize();

    // close the webview when finished
    // await closeInAppWebView();
    final tokenResponse = await c.getTokenResponse();

    final expiresAt = tokenResponse.expiresAt;
    final accessToken = tokenResponse.accessToken;
    final refreshToken = tokenResponse.refreshToken;

    if(expiresAt == null || accessToken == null || refreshToken == null) {
      throw Error();
    }

    return BackendSyncConfiguration(
        url: url,
        clientId: clientId,
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenEndpoint: tokenEndpoint,
        expiresAt: expiresAt,
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

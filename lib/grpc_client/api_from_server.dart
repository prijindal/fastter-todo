import 'dart:convert';

import 'package:grpc/grpc_connection_interface.dart';
import 'package:http/http.dart' as http;

import '../db/backend_sync_configuration.dart';
import '../schemaless_proto/application_services/v1/services.pbgrpc.dart';
import 'get_channel/main.dart';


class TokenResponse {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });
}

Future<TokenResponse> fetchAccessToken(BackendSyncConfiguration info) async {
  if (info.expiresAt.difference(DateTime.now()).inSeconds > 0) {
    return TokenResponse(
      accessToken: info.accessToken,
      refreshToken: info.refreshToken,
      expiresAt: info.expiresAt,
    );
  } else {
    var json = await http.post(
      Uri.parse(info.tokenEndpoint),
      body: {
        'grant_type': "refresh_token",
        'refresh_token': info.refreshToken,
        'client_id': info.clientId,
      },
    );
    final body = jsonDecode(json.body);
    print(body);
    final expiresIn = body["expires_in"] as int;
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    final accessToken = body["access_token"] as String;
    final refreshToken = body["refresh_token"] as String;
    return TokenResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }
}

class ApiFromServerInfo {
  final String url;
  final ClientChannelBase channel;
  final CallOptions callOptions;

  ApiFromServerInfo(BackendSyncConfiguration config)  : channel = getChannelFromUrl(
          config.url,
          tls: config.tls,
          allowInsecure: config.allowInsecure,
        ),
        url = config.url,
        callOptions = CallOptions(
          providers: [
            (metadata, uri) async {
              final token = await fetchAccessToken(config);
              metadata["authorization"] = "Bearer ${token.accessToken}";
            },
          ],
        );

  AuthServiceClient get authClient =>
      AuthServiceClient(channel, options: callOptions);
  HealthServiceClient get healthClient =>
      HealthServiceClient(channel, options: callOptions);
  EntityServiceClient get entityClient =>
      EntityServiceClient(channel, options: callOptions);
}

ConfigServiceClient getConfigApiFromUrl(
  String url, {
  bool tls = false,
  bool allowInsecure = false,
}) {
  final channel = getChannelFromUrl(
    url,
    tls: tls,
    allowInsecure: allowInsecure,
  );
  return ConfigServiceClient(channel);
}

import 'dart:async';

import '../grpc_client/api_from_server.dart';
import '../helpers/logger.dart';
import '../schemaless_proto/application_services/v1/services.pb.dart';
import 'backend_sync_configuration.dart';
import 'backend_sync_service.dart';

class BackendConnector {
  final ApiFromServerInfo _server;
  BackendSyncService? backendSyncService;

  ApiFromServerInfo get server => _server;
  bool get isConnected =>
      backendSyncService == null ? false : backendSyncService!.isConnected;

  BackendConnector({required ApiFromServerInfo server}) : _server = server {
    initConnection();
  }

  static Future<BackendConnector> init(BackendSyncConfiguration config) async {
    ApiFromServerInfo server = ApiFromServerInfo(
      config
    );
    AppLogger.instance.i("Initiating connection to ${config.url}");
    return BackendConnector(server: server);
  }

  Future<void> initConnection() async {
    AppLogger.instance.i("Initializing socket connection");
    try {
      backendSyncService = BackendSyncService(server: server);
      AppLogger.instance.i("Verifying auth");
      await _server.authClient.verifyUser(VerifyUserRequest());
      AppLogger.instance.i("Verified auth");

      await backendSyncService!.listenOnEntityHistory();
    } catch (e) {
      AppLogger.instance.e(e);
    }
  }
}

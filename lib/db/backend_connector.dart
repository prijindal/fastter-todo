import 'dart:async';

import '../grpc_client/api_from_server.dart';
import '../helpers/logger.dart';
import '../models/core.dart';
import '../schemaless_proto/application_services/v1/services.pb.dart';
import 'backend_sync_configuration.dart';
import 'backend_sync_service.dart';
import 'db_crud_operations.dart';
import 'local_settings.dart';

class BackendConnector {
  final ApiFromServerInfo _server;
  BackendSyncService? backendSyncService;

  ApiFromServerInfo get server => _server;
  bool get isConnected =>
      backendSyncService == null ? false : backendSyncService!.isConnected;

  BackendConnector({
    required SharedDatabase database,
    required DbCrudOperations dbCrudOperations,
    required ApiFromServerInfo server,
    required LocalSettings localSettings,
  }) : _server = server {
    initConnection(
      database: database,
      dbCrudOperations: dbCrudOperations,
      localSettings: localSettings,
    );
  }

  static Future<BackendConnector> init({
    required SharedDatabase database,
    required DbCrudOperations dbCrudOperations,
    required BackendSyncConfiguration config,
    required LocalSettings localSettings,
  }) async {
    ApiFromServerInfo server = ApiFromServerInfo(config);
    AppLogger.instance.i("Initiating connection to ${config.url}");
    return BackendConnector(
      database: database,
      dbCrudOperations: dbCrudOperations,
      server: server,
      localSettings: localSettings,
    );
  }

  Future<void> initConnection({
    required SharedDatabase database,
    required DbCrudOperations dbCrudOperations,
    required LocalSettings localSettings,
  }) async {
    AppLogger.instance.i("Initializing socket connection");
    try {
      backendSyncService = BackendSyncService(
        database: database,
        dbCrudOperations: dbCrudOperations,
        server: server,
        localSettings: localSettings,
      );
      AppLogger.instance.i("Verifying auth");
      await _server.authClient.verifyUser(VerifyUserRequest());
      AppLogger.instance.i("Verified auth");

      await backendSyncService!.listenOnEntityHistory();
    } catch (e) {
      AppLogger.instance.e(e);
    }
  }
}

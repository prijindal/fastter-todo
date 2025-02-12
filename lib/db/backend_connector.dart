import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../helpers/logger.dart';
import 'backend_sync_configuration.dart';
import 'backend_sync_service.dart';

Uri formWsUrl(String url) {
  // Transform a url in string format, to a Uri object and replace the schema from https to wss, or http to ws
  return Uri.parse(url).replace(scheme: url.startsWith("https") ? "wss" : "ws");
}

class BackendConnector {
  final io.Socket _socket;
  StreamSubscription<dynamic>? _subscription;
  bool get isConnected => _subscription != null;
  BackendSyncService? backendSyncService;

  BackendConnector({required io.Socket socket}) : _socket = socket {
    initConnection();
  }

  static Future<BackendConnector> init(BackendSyncConfiguration config) async {
    final socket = io.io(
        config.url,
        io.OptionBuilder()
            .setTransports(
                kIsWeb ? ['polling'] : ['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders(
                {'Authorization': 'Bearer ${config.jwtToken}'}) // optional
            .build());
    return BackendConnector(socket: socket);
  }

  Future<void> _onConnect() async {
    AppLogger.instance.i("connected received from server");
    backendSyncService = BackendSyncService(socket: _socket);
  }

  void _onDisconnect() {
    backendSyncService?.disconnect();
  }

  Future<void> initConnection() async {
    AppLogger.instance.i("Initializing web socket connection");
    try {
      _socket.connect();
      _socket.on("connected", (d) => _onConnect());
      _socket.on("server_actions", (d) => AppLogger.instance.d(d));
      _socket.onConnect((data) => AppLogger.instance.i("Connected to server"));
      _socket.onDisconnect((data) => _onDisconnect());
      _socket.onConnectError(
          (data) => AppLogger.instance.i("Error in connection"));
      _socket.onError((data) => AppLogger.instance.i("Error occurred"));
    } catch (e) {
      AppLogger.instance.e(e);
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:uuid/uuid.dart';

import '../helpers/logger.dart';
import 'backend/entity_types.dart';
import 'backend_sync.dart';

Uri formWsUrl(String url) {
  // Transform a url in string format, to a Uri object and replace the schema from https to wss, or http to ws
  return Uri.parse(url).replace(scheme: url.startsWith("https") ? "wss" : "ws");
}

class BackendConnector {
  final io.Socket _socket;
  StreamSubscription<dynamic>? _subscription;
  bool get isConnected => _subscription != null;

  BackendConnector({required io.Socket socket}) : _socket = socket {
    initConnection();
  }

  static Future<BackendConnector> init(BackendSyncConfiguration config) async {
    final socket = io.io(
        config.url,
        io.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders(
                {'Authorization': 'Bearer ${config.jwtToken}'}) // optional
            .build());
    return BackendConnector(socket: socket);
  }

  Future<List<EntityActionResponse>> _emitActions(
      List<EntityActionBase> actions) {
    var completer = Completer<List<EntityActionResponse>>();
    _socket.emitWithAck(
        "actions", jsonEncode(actions.map((e) => e.toJson()).toList()),
        ack: (List<dynamic> data) {
      completer.complete(data
          .map((a) => EntityActionResponse.fromJson(a as Map<String, dynamic>))
          .toList());
    });
    return completer.future;
  }

  Future<void> _onConnect() async {
    AppLogger.instance.i("connected received from server");
    final data = await _emitActions([
      EntityActionCreate(entityName: "todos", payload: {}, id: Uuid().v4())
    ]);
    AppLogger.instance.i(data);
    AppLogger.instance.i("Test action sent");
  }

  Future<void> initConnection() async {
    AppLogger.instance.i("Initializing web socket connection");
    try {
      _socket.connect();
      _socket.on("connected", (d) => _onConnect());
      _socket.onConnect((data) => AppLogger.instance.i("Connected to server"));
      _socket.onDisconnect(
          (data) => AppLogger.instance.i("Disconnected from server"));
      _socket.onConnectError(
          (data) => AppLogger.instance.i("Error in connection"));
      _socket.onError((data) => AppLogger.instance.i("Error occurred"));
    } catch (e) {
      AppLogger.instance.e(e);
    }
  }
}

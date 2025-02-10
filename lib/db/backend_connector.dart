import 'dart:async';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:watch_it/watch_it.dart';

import '../helpers/logger.dart';
import '../models/core.dart';
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
  SharedDatabase get _database => GetIt.I<SharedDatabase>();
  Timer? _timer;

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

  Future<void> _sendQueueData() async {
    final queue = await _database.managers.entityActionsQueue.get();
    if (queue.isEmpty) return;
    final List<EntityActionBase> actions = queue.map<EntityActionBase>((a) {
      if (a.action == "CREATE") {
        return EntityActionCreate(
            entityName: a.name,
            payload: a.payload,
            id: a.ids[0],
            timestamp: a.timestamp);
      } else if (a.action == "UPDATE") {
        return EntityActionUpdate(
            entityName: a.name,
            payload: a.payload,
            ids: a.ids,
            timestamp: a.timestamp);
      } else if (a.action == "DELETE") {
        return EntityActionDelete(
            entityName: a.name,
            payload: a.payload,
            ids: a.ids,
            timestamp: a.timestamp);
      }
      throw Error();
    }).toList();
    final data = await _emitActions(actions);
    AppLogger.instance.i(data.map((a) => a.toJson()).toList());
    await _database.managers.entityActionsQueue
        .filter((f) => f.requestId.isIn(queue.map((a) => a.requestId).toList()))
        .delete();
  }

  Future<void> _onConnect() async {
    AppLogger.instance.i("connected received from server");
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _sendQueueData());
  }

  void _onDisconnect() {
    _timer?.cancel();
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

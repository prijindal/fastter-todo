import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'backend_sync.dart';

Uri formWsUrl(String url) {
  // Transform a url in string format, to a Uri object and replace the schema from https to wss, or http to ws
  return Uri.parse(url).replace(scheme: url.startsWith("https") ? "wss" : "ws");
}

class BackendConnector {
  final WebSocketChannel _channel;
  StreamSubscription<dynamic>? _subscription;
  bool get isConnected => _subscription != null;

  BackendConnector({required WebSocketChannel channel}) : _channel = channel {
    initConnection();
  }

  static Future<BackendConnector> init(BackendSyncConfiguration config) async {
    final channel = WebSocketChannel.connect(formWsUrl(config.url));
    return BackendConnector(channel: channel);
  }

  Future<void> initConnection() async {
    await _channel.ready;
    _channel.sink.add("Hello from client");
    _subscription = _channel.stream.listen((message) {
      print("Received: $message");
    });
  }
}

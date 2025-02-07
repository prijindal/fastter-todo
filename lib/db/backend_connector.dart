import 'package:web_socket_channel/web_socket_channel.dart';

import 'backend_sync.dart';

Uri formWsUrl(String url) {
  // Transform a url in string format, to a Uri object and replace the schema from https to wss, or http to ws
  return Uri.parse(url).replace(scheme: url.startsWith("https") ? "wss" : "ws");
}

class BackendConnector {
  final WebSocketChannel channel;

  BackendConnector({required this.channel});

  static Future<BackendConnector> init(BackendSyncConfiguration config) async {
    final channel = WebSocketChannel.connect(formWsUrl(config.url));
    return BackendConnector(channel: channel);
  }
}

import 'package:grpc/grpc_connection_interface.dart';

import '../schemaless_proto/application/services.pbgrpc.dart';
import 'get_channel/main.dart';

class ApiFromServerInfo {
  final String url;
  final ClientChannelBase channel;
  final CallOptions callOptions;

  ApiFromServerInfo({
    required this.url,
    required String jwtToken,
    bool tls = false,
    bool allowInsecure = false,
  })  : channel = getChannelFromUrl(
          url,
          tls: tls,
          allowInsecure: allowInsecure,
        ),
        callOptions = CallOptions(
          metadata: {"authorization": "Bearer $jwtToken"},
        );

  AuthServiceClient get authClient =>
      AuthServiceClient(channel, options: callOptions);
  HealthServiceClient get healthClient =>
      HealthServiceClient(channel, options: callOptions);
  EntityServiceClient get entityClient =>
      EntityServiceClient(channel, options: callOptions);
}

LoginServiceClient getLoginApiFromUrl(
  String url, {
  bool tls = false,
  bool allowInsecure = false,
}) {
  final channel = getChannelFromUrl(
    url,
    tls: tls,
    allowInsecure: allowInsecure,
  );
  return LoginServiceClient(channel);
}

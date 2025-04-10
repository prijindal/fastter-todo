import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

ClientChannelBase getChannelFromUrl(
  String url, {
  bool tls = false,
  bool allowInsecure = false,
}) {
  var uri = Uri.parse(url);
  return ClientChannel(
    uri.host,
    port: uri.port,
    options: ChannelOptions(
      credentials:
          tls
              ? ChannelCredentials.secure(
                onBadCertificate: (certificate, host) => allowInsecure,
              )
              : ChannelCredentials.insecure(),
    ),
  );
}

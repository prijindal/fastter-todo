import 'package:grpc/grpc_connection_interface.dart';
import 'package:grpc/grpc_web.dart';

ClientChannelBase getChannelFromUrl(
  String url, {
  bool tls = false,
  bool allowInsecure = false,
}) {
  var uri = Uri.parse(url);
  return GrpcWebClientChannel.xhr(uri);
}

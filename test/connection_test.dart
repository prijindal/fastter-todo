import 'package:fastter_todo/grpc_client/api_from_server.dart';
import 'package:fastter_todo/schemaless_proto/types/v1/openid.pb.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  test('GRPC connection test', () async {
    var config =
        getConfigApiFromUrl("grpc://fastter.prijindal.click:443", tls: true);

    var response =
        await config.getOpenIdConfiguration(GetOpenIdConfigurationRequest());
    expect(response.authorizationEndpoint,
        "https://keycloak.prijindal.click/realms/fastter/protocol/openid-connect/auth");
  });
}

import 'package:openid_client/openid_client_io.dart';

import '../url_launcher.dart';

Future<Credential> openidAuthorize(Client client) async {
  var authenticator = Authenticator(client,
      port: 4000, urlLancher: urlLauncher, scopes: ["offline_access"]);
  Credential credential = await authenticator.authorize();

  return credential;
}

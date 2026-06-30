import 'package:openid_client/openid_client_browser.dart';

Future<Credential> openidAuthorize(Client client) async {
  var authenticator = Authenticator(client, scopes: ["offline_access"]);
  authenticator.authorize();
  Credential? credential = await authenticator.credential;

  if (credential == null) {
    throw "Credentials not found";
  }

  return credential;
}

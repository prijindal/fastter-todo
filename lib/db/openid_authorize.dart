import 'package:flutter/foundation.dart';
import 'package:openid_client/openid_client_browser.dart' as browser_openid;
import 'package:openid_client/openid_client_io.dart' as openid;
import 'package:url_launcher/url_launcher.dart';

Future<void> urlLauncher(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

Future<openid.Credential> openidAuthorize(openid.Client client) async {
  openid.Credential? credential;
  if (!kIsWeb) {
    var authenticator = openid.Authenticator(client,
        port: 4000, urlLancher: urlLauncher, scopes: ["offline_access"]);
    credential = await authenticator.authorize();
  } else {
    var authenticator =
        browser_openid.Authenticator(client, scopes: ["offline_access"]);
    authenticator.authorize();
    credential = await authenticator.credential;
  }

  if (credential == null) {
    throw "Credentials not found";
  }

  return credential;
}

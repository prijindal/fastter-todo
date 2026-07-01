import 'dart:async';

// Or use: import 'dart:html' as html; if targeting older SDKs
import 'package:openid_client/openid_client_browser.dart';
import 'package:web/web.dart' as web; // Modern Flutter web interop package

Future<Credential?> openidAuthorize(Client client) async {
  return await _authenticateWithPopup(
    client: client,
    scopes: ["offline_access"],
  );
}

Future<Credential?> _authenticateWithPopup({
  required Client client,
  required List<String> scopes,
}) async {
  // 2. Setup the Authorization Code flow (or Implicit if your provider requires it)
  // Ensure the redirectUri points explicitly to your static callback page
  var currentUri = Uri.parse(web.window.location.href);
  var redirectUri = Uri(
    scheme: currentUri.scheme,
    host: currentUri.host,
    port: currentUri.port,
    path: '/auth_callback.html', // Point to the static file
  );

  var flow = Flow.authorizationCodeWithPKCE(client)
    ..redirectUri = redirectUri
    ..scopes.addAll(scopes);

  String authUrl = flow.authenticationUri.toString();

  // 3. Open the authentication window as a popup
  final width = 500;
  final height = 600;
  final left = (web.window.screen.width - width) / 2;
  final top = (web.window.screen.height - height) / 2;

  var popupWindow = web.window.open(
    authUrl,
    'OIDC Authentication',
    'width=$width,height=$height,top=$top,left=$left,status=no,resizable=yes,scrollbars=yes',
  );

  if (popupWindow == null) {
    throw Exception("Popup blocked by browser.");
  }

  // 4. Listen for the token/code message from the popup
  final completer = Completer<Credential>();
  late StreamSubscription<web.MessageEvent> subscription;

  subscription = web.window.onMessage.listen((web.MessageEvent event) async {
    // Basic origin protection check
    if (event.origin != web.window.location.origin) return;

    final String? responseUrlStr = event.data?.toString();
    if (responseUrlStr != null && responseUrlStr.contains('code=')) {
      // Clean up the stream listener
      await subscription.cancel();

      try {
        // 5. Feed the captured callback URL back into openid_client to resolve tokens
        var responseUri = Uri.parse(responseUrlStr);

        String? code = responseUri.queryParameters["code"];
        String? state = responseUri.queryParameters["state"];
        String? sessionState = responseUri.queryParameters["session_state"];
        String? iss = responseUri.queryParameters["iss"];
        // 1. Reconstruct the query parameter map exactly as received by the browser
        if (code != null && state != null) {
          final Map<String, String> callbackParameters = {
            'code': code,
            'state': state,
          };

          if (sessionState != null) {
            callbackParameters['session_state'] = sessionState;
          }
          if (iss != null) {
            callbackParameters['iss'] = iss;
          }
          var credential = await flow.callback(callbackParameters);

          return completer.complete(credential);
        } else {
          completer.completeError("Invalid response");
        }
      } catch (e) {
        completer.completeError(e);
      }
    }
  });

  return completer.future;
}

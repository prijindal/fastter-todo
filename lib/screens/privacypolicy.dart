import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Privacy Policy'),
        ),
        body: WebView(
          initialUrl: 'https://fastter.easycode.club/privacy-policy.html',
        ),
      );
}

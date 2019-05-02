import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const applicationName = 'Fastter Todo';
    const applicationVersion = '0.0.1';
    final Widget applicationIcon = Image.asset(
      'assets/icon/ic_launcher.png',
      width: 48,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: WebView(
        initialUrl: 'https://fastter.easycode.club/privacy-policy.html',
      ),
    );
  }
}

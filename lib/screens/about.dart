import 'dart:io';
import 'package:fastter_todo/components/imageviewer.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreen createState() => _AboutScreen();
}

class _AboutScreen extends State<AboutScreen> {
  var _applicationName = 'Fastter Todo';
  var _applicationVersion = '0.0.1';
  final Widget applicationIcon = Image.asset(
    'assets/icon/ic_launcher.png',
    width: 48,
  );

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      PackageInfo.fromPlatform().then((packageInfo) {
        setState(() {
          _applicationName = packageInfo.appName;
          _applicationVersion = packageInfo.version;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('About'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconTheme(
                    data: const IconThemeData(size: 48),
                    child: applicationIcon,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _applicationName,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Text(
                          _applicationVersion,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Container(height: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: Text('Made by'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(right: 6),
                  child: ImageViewer(
                    NetworkImage(
                      'https://avatars2.githubusercontent.com/u/10034872?s=50&v=4',
                    ),
                    fullImageProvider: NetworkImage(
                      'https://avatars2.githubusercontent.com/u/10034872?s=960&v=4',
                    ),
                  ),
                ),
                Container(
                  child: Text('Priyanshu Jindal'),
                ),
              ],
            ),
            TextButton(
              child: Text(
                MaterialLocalizations.of(context).viewLicensesButtonLabel,
              ),
              onPressed: () {
                showLicensePage(
                  context: context,
                  applicationName: _applicationName,
                  applicationVersion: _applicationVersion,
                  applicationIcon: applicationIcon,
                );
              },
            ),
          ],
        ),
      );
}

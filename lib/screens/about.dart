import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
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
        title: const Text('About'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTheme(
                  data: const IconThemeData(size: 48), child: applicationIcon),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(applicationName,
                        style: Theme.of(context).textTheme.headline),
                    Text(applicationVersion,
                        style: Theme.of(context).textTheme.body1),
                    Container(height: 18),
                  ],
                ),
              ),
            ],
          ),
          FlatButton(
            child:
                Text(MaterialLocalizations.of(context).viewLicensesButtonLabel),
            onPressed: () {
              showLicensePage(
                context: context,
                applicationName: applicationName,
                applicationVersion: applicationVersion,
                applicationIcon: applicationIcon,
              );
            },
          ),
        ],
      ),
    );
  }
}

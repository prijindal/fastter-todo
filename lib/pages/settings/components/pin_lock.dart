import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../models/settings.dart';

class PinLockScreen extends StatelessWidget {
  const PinLockScreen({
    super.key,
    required this.title,
    this.validator,
    this.onCompleted,
  });

  final String title;
  final String? Function(String?)? validator;
  final void Function(String)? onCompleted;

  static Future<bool> createNewPin(BuildContext context) async {
    final settingsStorage =
        Provider.of<SettingsStorageNotifier>(context, listen: false);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => PinLockScreen(
        title: "Enter a pin",
        onCompleted: (pin) async {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => PinLockScreen(
              title: "Confirm pin",
              validator: (s) {
                return s == pin ? null : 'Pin is incorrect';
              },
              onCompleted: (confirmedPin) {
                if (confirmedPin == pin) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
          );
          if (result != null && result) {
            await settingsStorage.writePin(pin);
          }
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop(result);
        },
      ),
    );
    return result ?? false;
  }

  static Future<bool> verifyPin(BuildContext context) async {
    final settingsStorage =
        Provider.of<SettingsStorageNotifier>(context, listen: false);
    final dbPin = await settingsStorage.readPin();
    if (dbPin == null) {
      return false;
    }
    final result = await showDialog<bool>(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => PinLockScreen(
        title: "Enter the pin",
        onCompleted: (pin) async {
          if (pin == dbPin) {
            Navigator.of(context).pop(true);
          } else {
            Navigator.of(context).pop(false);
          }
        },
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Pinput(
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              validator: validator,
              onCompleted: onCompleted,
            ),
          ],
        ),
      ),
    );
  }
}

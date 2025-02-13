import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    String? title,
    String? content,
    String? cancelText,
    String? confirmText,
  })  : title = title ?? "Are you sure?",
        content = content ?? "Are you sure you want to continue?",
        cancelText = cancelText ?? "No",
        confirmText = confirmText ?? "Yes";

  final String title;
  final String content;
  final String cancelText;
  final String confirmText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  String? title,
  String? content,
  String? cancelText,
  String? confirmText,
}) =>
    showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        content: content,
        cancelText: cancelText,
        confirmText: confirmText,
      ),
    );

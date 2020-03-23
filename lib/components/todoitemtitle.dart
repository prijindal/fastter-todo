import 'dart:io';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_todo/helpers/encrypt.dart';
import 'package:flutter/material.dart';

class TodoItemTitle extends StatefulWidget {
  const TodoItemTitle({@required this.todo});

  final Todo todo;
  @override
  _TodoItemTitleState createState() => _TodoItemTitleState();
}

class _TodoItemTitleState extends State<TodoItemTitle> {
  bool decrypted = false;
  String decryptedText = '';

  Future<void> decrypt(String password) async {
    if (Platform.isAndroid || Platform.isIOS) {
      final encryptionService = EncryptionService.getInstance();
      encryptionService.setEncryptionKey(password, true);
      final decrypt = encryptionService.decrypt(widget.todo.title);
      setState(() {
        decryptedText = decrypt;
        decrypted = true;
      });
    } else {
      setState(() {
        decryptedText = 'Not yet implemented';
        decrypted = true;
      });
    }
  }

  Future<void> _inputPassword() async {
    final passwordController = TextEditingController();
    final shouldDecrypt = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Type your Password'),
        content: TextFormField(
          controller: passwordController,
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: const Text('Decrypt'),
            onPressed: () {
              // Save name
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
    if (shouldDecrypt) {
      await decrypt(passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.todo.encrypted) {
      if (decrypted) {
        return GestureDetector(
          onTap: () {
            setState(() {
              decrypted = false;
              decryptedText = '';
            });
          },
          child: Row(
            children: <Widget>[
              Icon(Icons.lock),
              TodoItemTitle(
                todo: widget.todo.copyWith(
                  encrypted: false,
                  title: decryptedText,
                ),
              ),
            ],
          ),
        );
      }
      return GestureDetector(
        onTap: _inputPassword,
        child: Row(
          children: <Widget>[
            Icon(Icons.lock),
            const Text('Encrypted'),
          ],
        ),
      );
    }
    return Text(
      widget.todo.title,
      style: TextStyle(
        decoration: widget.todo.completed == true
            ? TextDecoration.lineThrough
            : TextDecoration.none,
      ),
    );
  }
}

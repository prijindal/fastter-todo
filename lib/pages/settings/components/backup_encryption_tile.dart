import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../../models/db_selector.dart';

class BackupEncryptionTile extends StatefulWidget {
  const BackupEncryptionTile({super.key});

  @override
  State<BackupEncryptionTile> createState() => _BackupEncryptionTileState();
}

class _BackupEncryptionTileState extends State<BackupEncryptionTile> {
  bool? _encryptionStatus;

  @override
  void initState() {
    _loadEncryptionStatus();
    super.initState();
  }

  void _loadEncryptionStatus() {
    Provider.of<DbSelector>(context, listen: false)
        .io
        .readEncrptionStatus()
        .then((status) {
      setState(() {
        _encryptionStatus = status;
      });
    });
  }

  String _buildTitle() {
    if (_encryptionStatus == null) {
      return "Loading";
    }
    if (_encryptionStatus!) {
      return "Encrypted";
    } else {
      return "Not encrypted";
    }
  }

  Future<String?> _showPasswordDialog() async {
    final formKey = GlobalKey<FormBuilderState>();
    final password = await showDialog<String?>(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Enter password"),
        ),
        body: Center(
          child: SizedBox(
            width: 400,
            child: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: "password",
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    autofocus: true,
                  ),
                  const SizedBox(height: 10),
                  MaterialButton(
                    onPressed: () {
                      // Validate and save the form values
                      formKey.currentState?.saveAndValidate();
                      Navigator.of(context).pop(
                        formKey.currentState?.value["password"] as String?,
                      );
                    },
                    child: const Text('Confirm'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return password;
  }

  Future<void> _enableEncryption() async {
    final newPassword = await _showPasswordDialog();
    if (newPassword == null && context.mounted) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password not set"),
        ),
      );
      return;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Backup encryption is now enabled"),
        ),
      );
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        await Provider.of<DbSelector>(context, listen: false)
            .io
            .writeEncryptionKey(newPassword);
        setState(() {
          _encryptionStatus = true;
        });
      }
    }
  }

  Future<void> _disableEncryption() async {
    final inputedPassword = await _showPasswordDialog();
    final existingPassword =
        // ignore: use_build_context_synchronously
        await Provider.of<DbSelector>(context, listen: false)
            .io
            .readEncryptionKey();
    if (inputedPassword != existingPassword) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid password"),
        ),
      );
      return;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Removed backup encryption"),
        ),
      );
      // ignore: use_build_context_synchronously
      await Provider.of<DbSelector>(context, listen: false)
          .io
          .writeEncryptionKey(null);
      setState(() {
        _encryptionStatus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      tristate: true,
      enabled: _encryptionStatus != null,
      value: _encryptionStatus,
      title: Text(_buildTitle()),
      subtitle: Text(
          "Backup Encryption key is used for encryption your cloud backups"),
      onChanged: (newValue) {
        // show dialog for accepting key
        if (newValue == true) {
          // Encryption is now enabled
          _enableEncryption();
        } else {
          // Encryption is now disabled
          _disableEncryption();
        }
      },
    );
  }
}

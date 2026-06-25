import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../db/backend_sync_configuration.dart';
import '../../../helpers/logger.dart';

const allowedProtocols =
    kIsWeb ? ["https", "http", "ws", "wss"] : ["https", "http", "ws", "wss"];

class BackendTokenConfiguraion {
  String url;
  String jwtToken;
  bool tls = false;
  bool allowInsecure = false;

  BackendTokenConfiguraion({
    required this.url,
    required this.jwtToken,
    this.tls = false,
    this.allowInsecure = false,
  });
}

class NewBackendConfig extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  NewBackendConfig({super.key});

  Future<void> _login(BuildContext context) async {
    try {
      if (_formKey.currentState?.saveAndValidate() == true) {
        final config = _formKey.currentState!.value;

        final backendConfig = await BackendSyncConfigurationService.newBackend(
          syncUrl: config["syncUrl"] as String,
          authToken: config["authToken"] as String,
          syncIntervalSeconds: 60,
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop<BackendSyncConfiguration>(
          backendConfig,
        );
      } // Handle the submit action
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
      AppLogger.instance.e(e.toString(), error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: FormBuilder(
        key: _formKey,
        child: AutofillGroup(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              width: min(600, MediaQuery.of(context).size.width),
              child: ListView(
                children: [
                  FormBuilderTextField(
                    name: "syncUrl",
                    autofocus: true,
                    autofillHints: [AutofillHints.url],
                    decoration: InputDecoration(
                      labelText: 'URL, starts with $allowedProtocols',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.url(
                        protocols: allowedProtocols,
                        requireProtocol: true,
                      ),
                    ]),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    name: "authToken",
                    autofocus: false,
                    decoration: InputDecoration(labelText: 'Auth Token'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () => _login(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

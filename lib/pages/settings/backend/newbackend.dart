import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../db/backend_sync_configuration.dart';
import '../../../helpers/logger.dart';

const allowedProtocols = kIsWeb ? ["https", "http"] : ["grpc"];

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

        final token = await BackendSyncConfigurationService.login(
          url: config["url"] as String,
          email: config["email"] as String,
          password: config["password"] as String,
          tls: config["tls"] as bool,
          allowInsecure: config["allowInsecure"] as bool,
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop<BackendTokenConfiguraion>(
          BackendTokenConfiguraion(
            url: config["url"] as String,
            jwtToken: token,
            tls: config["tls"] as bool,
            allowInsecure: config["allowInsecure"] as bool,
          ),
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

  Future<void> _register(BuildContext context) async {
    try {
      if (_formKey.currentState?.saveAndValidate() == true) {
        final config = _formKey.currentState!.value;

        final token = await BackendSyncConfigurationService.register(
          url: config["url"] as String,
          email: config["email"] as String,
          password: config["password"] as String,
          tls: config["tls"] as bool,
          allowInsecure: config["allowInsecure"] as bool,
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop<BackendTokenConfiguraion>(
          BackendTokenConfiguraion(
            url: config["url"] as String,
            jwtToken: token,
            tls: config["tls"] as bool,
            allowInsecure: config["allowInsecure"] as bool,
          ),
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
                    name: "url",
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
                    name: "email",
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: [AutofillHints.email],
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    name: "password",
                    obscureText: true,
                    autofillHints: [AutofillHints.password],
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: FormBuilderValidators.required(),
                  ),
                  SizedBox(height: 10),
                  FormBuilderCheckbox(
                    initialValue: false,
                    enabled: !kIsWeb,
                    name: "tls",
                    title: Text("TLS Enabled"),
                    decoration: InputDecoration(labelText: 'TLS is enabled'),
                  ),
                  SizedBox(height: 10),
                  FormBuilderCheckbox(
                    initialValue: false,
                    enabled: !kIsWeb,
                    name: "allowInsecure",
                    title: Text("Allow Insecure"),
                    decoration: InputDecoration(
                      labelText: 'Allow Insecure Connection',
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () => _login(context),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: const Text('Register'),
                    onPressed: () => _register(context),
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

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

const allowedProtocols = kIsWeb ? ["https", "http"] : ["grpc"];

class BackendLoginConfiguraion {
  String url;
  String email;
  String password;
  bool tls = false;
  bool allowInsecure = false;

  BackendLoginConfiguraion({
    required this.url,
    required this.email,
    required this.password,
    this.tls = false,
    this.allowInsecure = false,
  });
}

class NewBackendConfig extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  NewBackendConfig({super.key});

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
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() == true) {
                        final config = _formKey.currentState!.value;
                        Navigator.of(context).pop<BackendLoginConfiguraion>(
                          BackendLoginConfiguraion(
                            url: config["url"] as String,
                            email: config["email"] as String,
                            password: config["password"] as String,
                            tls: config["tls"] as bool,
                            allowInsecure: config["allowInsecure"] as bool,
                          ),
                        );
                      } // Handle the submit action
                    },
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

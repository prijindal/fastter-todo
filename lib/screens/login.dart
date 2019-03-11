import 'package:flutter/material.dart';

import '../components/loginform.dart';
import '../components/googlesigninform.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          GoogleSignInForm(),
          Text("Or"),
          LoginForm(),
        ],
      ),
    );
  }
}

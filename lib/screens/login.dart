import 'package:flutter/material.dart';

import '../components/googlesigninform.dart';
import '../components/loginform.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Column(
          children: [
            GoogleSignInForm(),
            const Text('Or'),
            LoginForm(),
          ],
        ),
      );
}

import 'package:flutter/material.dart';

import '../components/googlesigninform.dart';
import '../components/loginform.dart';
import 'about.dart';
import 'privacypolicy.dart';
import 'signup.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Column(
          children: [
            // GoogleSignInForm(),
            // const Text('Or'),
            LoginForm(),
            const Text('Or'),
            ElevatedButton(
              child: const Text('Signup'),
              // color: Colors.grey[300],
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (context) => SignupScreen(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Read About Us'),
              // color: Colors.grey[300],
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (context) => AboutScreen(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Read Our Privacy Policy'),
              // color: Colors.grey[300],
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (context) => PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      );
}

// import 'dart:io';
// import 'package:fastter_todo/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';

// import '../models/user.model.dart';
// import '../store/user.dart';

// class GoogleSignInForm extends StatelessWidget {
//   @protected
//   @override
//   Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
//         bloc: fastterUser,
//         builder: (context, state) => _GoogleSignInForm(
//           user: state,
//           loginWithGoogle: (idToken) =>
//               fastterUser.add(GoogleLoginUserEvent(idToken)),
//         ),
//       );
// }

// class _GoogleSignInForm extends StatelessWidget {
//   const _GoogleSignInForm({
//     required this.loginWithGoogle,
//     required this.user,
//   });

//   final UserState user;
//   final void Function(String) loginWithGoogle;

//   void _startGoogleFlow(BuildContext context) {
//     if (Platform.isAndroid || Platform.isIOS) {
//       final _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
//       _googleSignIn.signIn().then((account) {
//         account?.authentication.then((auth) {
//           loginWithGoogle(auth.idToken!);
//         });
//       });
//       Navigator.of(context).push<void>(
//         MaterialPageRoute<void>(
//           builder: (context) => Scaffold(
//             body: const Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//         ),
//       );
//     } else {
//       Navigator.of(context).push<void>(
//         MaterialPageRoute<void>(
//           builder: (context) => _GoogleSignInScreen(
//             loginWithGoogle: loginWithGoogle,
//             user: user,
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) => Container(
//         child: SignInButton(
//           Buttons.Google,
//           onPressed: () => _startGoogleFlow(context),
//         ),
//       );
// }

// class _GoogleSignInScreen extends StatefulWidget {
//   const _GoogleSignInScreen({
//     required this.loginWithGoogle,
//     required this.user,
//   });

//   final UserState user;
//   final void Function(String) loginWithGoogle;

//   @override
//   _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
// }

// class _GoogleSignInScreenState extends State<_GoogleSignInScreen> {
//   final _idTokenController = TextEditingController(text: '');
//   final String urlString = '${Fastter.instance.url}/google/oauth2';

//   void _onLogin() {
//     widget.loginWithGoogle(_idTokenController.text);
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: const Text('Sign in with google'),
//         ),
//         body: widget.user.isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Container(
//                 child: Column(
//                   children: <Widget>[
//                     const Text('Go to this url'),
//                     Text(urlString),
//                     const Text('And input the string below'),
//                     TextField(
//                       controller: _idTokenController,
//                     ),
//                     ElevatedButton(
//                       child: const Text('Login'),
//                       onPressed: _onLogin,
//                     )
//                   ],
//                 ),
//               ),
//       );
// }

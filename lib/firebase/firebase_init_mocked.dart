// These are mock classes to be used when firebase is not present
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../helpers/logger.dart';

@immutable
class FirebaseOptions {}

@immutable
class FirebaseException implements Exception {
  final String code;
  final String message;

  const FirebaseException({required this.code, required this.message});
}

class User {
  final String? displayName;
  final String? email;
  final String uid;
  final String? photoURL;

  User(this.photoURL,
      {required this.displayName, required this.email, required this.uid});
}

class Firebase {
  static Firebase get instance => Firebase();

  static List<String> apps = [];
}

class Reference {
  List<int> getData() {
    return [];
  }
}

class FirebaseStorage {
  static FirebaseStorage get instance => FirebaseStorage();

  Reference ref(String path) {
    return Reference();
  }
}

class FirebaseAuth {
  static FirebaseAuth get instance => FirebaseAuth();
  Stream<User?> authStateChanges() {
    return Stream.empty();
  }

  Future<void> signOut() async {}

  User? get currentUser => null;
}

final authProviders = <String>[];

class SignedOutAction {
  /// A callback that is being called when user has signed out.
  final void Function(BuildContext context) callback;

  /// {@macro ui.auth.actions.signed_out_action}
  SignedOutAction(this.callback);
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.providers,
    required this.actions,
  });

  final List<String> providers;
  final List<SignedOutAction> actions;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key, required this.providers});

  final List<String> providers;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

Future<void> firebaseInit() async {}

bool isFirebaseInitialized() {
  return false;
}

class CrashlyticsLogPrinter extends PrettyPrinter {
  CrashlyticsLogPrinter() : super();
}

String parseErrorToString(
  Object e,
  StackTrace stack, [
  String defaultMessage = "Error While syncing",
]) {
  AppLogger.instance.e(
    defaultMessage,
    error: e,
    stackTrace: stack,
  );
  var error = defaultMessage;
  return error;
}

import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/firebase.dart';
import '../store/user.dart';

Future<void> _clearPersisted() async {
  final _sharedPreferences = await SharedPreferences.getInstance();
  await _sharedPreferences.clear();
}

final UserBloc fastterUser = UserBloc(
  initMessaging: initMessaging,
  onLogout: _clearPersisted,
);

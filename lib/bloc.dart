import 'dart:io';
import 'package:fastter_todo/helpers/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../store/user.dart';

Future<void> _clearPersisted() async {
  if (Platform.isAndroid || Platform.isIOS) {
    final _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.clear();
  } else {
    final homeFolder = Platform.environment['HOME'];
    final directory = Directory('$homeFolder/.config/fastter_todo');
    if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
  }
}

final UserBloc fastterUser = UserBloc(
  initMessaging: initMessaging,
  onLogout: _clearPersisted,
);

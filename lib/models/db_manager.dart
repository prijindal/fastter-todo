import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/logger.dart';
import 'core.dart';

const dbImplementationKey = "DB_IMPLEMENTATION";
const dbRemoteSettings = "DB_REMOTE_SETTINGS";

class RemoteDbSettings {
  final String url;
  final String? token;

  RemoteDbSettings({
    required this.url,
    this.token,
  });

  static RemoteDbSettings fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return RemoteDbSettings(
      url: map['url'] as String,
      token: map['token'] as String?,
    );
  }

  String toJson() {
    return jsonEncode({
      'url': url,
      'token': token,
    });
  }
}

enum DbSelectorType { local, remote }

class DbSelector {
  final SharedDatabase database;
  final DbSelectorType? dbType;
  final RemoteDbSettings? remoteDbSettings;

  DbSelector({
    required this.database,
    required this.dbType,
    this.remoteDbSettings,
  });

  static Future<DbSelector> localOnly() async {
    return DbSelector(
      database: SharedDatabase.local(),
      dbType: DbSelectorType.local,
    );
  }

  static Future<DbSelector> initDb() async {
    final implementationString =
        await SharedPreferencesAsync().getString(dbImplementationKey);
    AppLogger.instance
        .d("Implementation of db detected as $implementationString");
    final savedDbType = implementationString == null
        ? DbSelectorType.local
        : DbSelectorType.values.asNameMap()[implementationString] ??
            DbSelectorType.local;
    if (savedDbType == DbSelectorType.local) {
      return DbSelector(database: SharedDatabase.local(), dbType: savedDbType);
    } else {
      final remoteSettingsString =
          await SharedPreferencesAsync().getString(dbRemoteSettings);
      if (remoteSettingsString == null) {
        throw Exception('Remote settings not initialized');
      }
      final remoteSettings = RemoteDbSettings.fromJson(remoteSettingsString);
      AppLogger.instance
          .d("Initiating remote database with ${remoteSettings.url}");
      return DbSelector(
        database: SharedDatabase.hrana(
          jwtToken: remoteSettings.token,
          url: remoteSettings.url,
        ),
        dbType: savedDbType,
        remoteDbSettings: remoteSettings,
      );
    }
  }

  static Future<void> setLocal() async {
    await SharedPreferencesAsync().setString(dbImplementationKey, 'local');
  }

  static Future<void> setRemote(RemoteDbSettings settings) async {
    await SharedPreferencesAsync().setString(
      dbImplementationKey,
      'remote',
    );
    await SharedPreferencesAsync().setString(
      dbRemoteSettings,
      settings.toJson(),
    );
  }
}

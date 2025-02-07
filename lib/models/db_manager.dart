import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/dbio.dart';
import '../helpers/logger.dart';
import 'core.dart';

const dbImplementationKey = "DB_IMPLEMENTATION";
const dbRemoteSettings = "DB_REMOTE_SETTINGS";

enum RemoteDbImplementationType { hrana, libsql }

class RemoteDbSettings {
  final String url;
  final String? token;
  final RemoteDbImplementationType implementationType;

  RemoteDbSettings({
    required this.url,
    this.token,
    required this.implementationType,
  });

  static RemoteDbSettings fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return RemoteDbSettings(
      url: map['url'] as String,
      token: map['token'] as String?,
      implementationType: RemoteDbImplementationType.values
          .asNameMap()[map['implementationType']]!,
    );
  }

  String toJson() {
    return jsonEncode({
      'url': url,
      'token': token,
      'implementationType': implementationType.name,
    });
  }
}

enum DbSelectorType { local, remote }

class DbManager {
  SharedDatabase? _database;
  DbSelectorType? _dbType;
  RemoteDbSettings? remoteDbSettings;

  SharedDatabase get database {
    if (_database == null) {
      throw Exception('Database not initialized');
    }
    return _database!;
  }

  DatabaseIO get io => DatabaseIO(_database!);
  DbSelectorType get dbType => _dbType!;

  bool get isInitialized => _database != null;

  DbManager();

  static Future<DbManager> autoInit() async {
    final dbManager = DbManager();
    await dbManager.initDb();
    return dbManager;
  }

  factory DbManager.localOnly() {
    final dbManager = DbManager();
    dbManager.initLocal();
    return dbManager;
  }

  void initLocal() {
    AppLogger.instance.d("Initiating local database");
    _database = SharedDatabase.local();
  }

  Future<void> initDb() async {
    final implementationString =
        await SharedPreferencesAsync().getString(dbImplementationKey);
    AppLogger.instance
        .d("Implementation of db detected as $implementationString");
    _dbType = implementationString == null
        ? DbSelectorType.local
        : DbSelectorType.values.asNameMap()[implementationString] ??
            DbSelectorType.local;
    if (_dbType == DbSelectorType.local) {
      initLocal();
    } else {
      final remoteSettingsString =
          await SharedPreferencesAsync().getString(dbRemoteSettings);
      if (remoteSettingsString == null) {
        throw Exception('Remote settings not initialized');
      }
      final remoteSettings = RemoteDbSettings.fromJson(remoteSettingsString);
      remoteDbSettings = remoteSettings;
      AppLogger.instance.d(
          "Initiating remote database with implementation type ${remoteSettings.implementationType} with ${remoteSettings.url}");
      if (remoteSettings.implementationType ==
          RemoteDbImplementationType.hrana) {
        _database = SharedDatabase.hrana(
          jwtToken: remoteSettings.token,
          url: remoteSettings.url,
        );
      } else {
        // final directory = await (getApplicationDocumentsDirectory());
        // final path = p.join(directory.path, "$dbName.sqlite");
        throw UnimplementedError();
        // _database = SharedDatabase.libsql(
        //   jwtToken: remoteSettings.token,
        //   url: remoteSettings.url,
        //   path: path,
        // );
      }
    }
  }

  Future<void> setLocal() async {
    await SharedPreferencesAsync().setString(dbImplementationKey, 'local');
  }

  Future<void> setRemote(RemoteDbSettings settings) async {
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

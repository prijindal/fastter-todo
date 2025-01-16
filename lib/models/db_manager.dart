import 'dart:convert';

import 'package:flutter/material.dart';
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

class DbManager extends ChangeNotifier {
  SharedDatabase? _database;
  DbSelectorType? _dbType;

  SharedDatabase get database {
    if (_database == null) {
      throw Exception('Database not initialized');
    }
    return _database!;
  }

  DatabaseIO get io => DatabaseIO(_database!);
  DbSelectorType get dbType => _dbType!;

  bool get isInitialized => _database != null;

  DbManager() {
    initDb();
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
      AppLogger.instance.d("Initiating local database");
      _database = SharedDatabase.local();
    } else {
      final remoteSettingsString =
          await SharedPreferencesAsync().getString(dbRemoteSettings);
      if (remoteSettingsString == null) {
        throw Exception('Remote settings not initialized');
      }
      final remoteSettings = RemoteDbSettings.fromJson(remoteSettingsString);
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
    notifyListeners();
    _addWatcher();
  }

  Future<void> _addWatcher() async {
    if (_database == null) return;
    final stream = _database!.tableUpdates();
    await for (final events in stream) {
      AppLogger.instance.d(events);
      await io.updateLastUpdatedTime();
    }
  }

  Future<void> setLocal() async {
    await SharedPreferencesAsync().setString(dbImplementationKey, 'local');
    notifyListeners();
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
    notifyListeners();
  }

  // These are helper methods for db deletion/updation etc
  Future<void> deleteTodosByIds(List<String> ids) async {
    await Future.wait([
      database.managers.comment.filter((f) => f.todo.isIn(ids)).delete(),
      database.managers.reminder.filter((f) => f.todo.isIn(ids)).delete(),
      database.managers.todo.filter((f) => f.id.isIn(ids)).delete(),
    ]);
  }
}

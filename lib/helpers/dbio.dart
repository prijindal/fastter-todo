import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/core.dart';
import '../models/drift.dart';
import 'constants.dart';
import 'logger.dart';

class DatabaseIO {
  static DatabaseIO? _instance;

  static DatabaseIO get instance {
    _instance ??= DatabaseIO();
    return _instance as DatabaseIO;
  }

  Future<String> extractDbJson() async {
    final db = await Future.wait([
      MyDatabase.instance.managers.todo.get(),
      MyDatabase.instance.managers.project.get(),
      MyDatabase.instance.managers.comment.get(),
      MyDatabase.instance.managers.reminder.get(),
    ]);
    String encoded = jsonEncode(
      {
        "todo": db[0],
        "project": db[1],
        "comment": db[2],
        "reminder": db[3],
      },
    );
    AppLogger.instance.i("Extracted data from database");
    return encoded;
  }

  Future<void> _jsonToDbTable(
      List<dynamic> entries,
      TableInfo<Table, dynamic> manager,
      Insertable Function(Map<String, dynamic>) toElement) async {
    await MyDatabase.instance.batch((batch) {
      batch.insertAll(
        manager,
        entries.map(
          (a) => toElement(a as Map<String, dynamic>),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Future<void> jsonToDb(String jsonEncoded) async {
    final decoded = jsonDecode(jsonEncoded);
    await Future.wait(
      [
        _jsonToDbTable(
          decoded["todo"] as List<dynamic>,
          MyDatabase.instance.todo,
          TodoData.fromJson,
        ),
        _jsonToDbTable(
          decoded["project"] as List<dynamic>,
          MyDatabase.instance.project,
          ProjectData.fromJson,
        ),
        _jsonToDbTable(
          decoded["comment"] as List<dynamic>,
          MyDatabase.instance.comment,
          CommentData.fromJson,
        ),
        _jsonToDbTable(
          decoded["reminder"] as List<dynamic>,
          MyDatabase.instance.reminder,
          ReminderData.fromJson,
        )
      ],
    );
    AppLogger.instance.d("Loaded data into database");
  }

  Future<bool> readEncrptionStatus() async {
    final keyStatus =
        await SharedPreferencesAsync().getBool(backupEncryptionStatus);
    return keyStatus != null && keyStatus;
  }

  Future<String?> readEncryptionKey() async {
    final keyStatus = await readEncrptionStatus();
    if (keyStatus == false) {
      // If key status is false, or not set, it means that backup encryption key is disabled
      return null;
    } else {
      // else, encryption is enabled, and password must be used
      // TODO: This is a placeholder, sercure storage will be used, and there will be a way to save this in UI
      return SharedPreferencesAsync().getString(lastUpdateTimeKey);
    }
  }

  Future<String?> readEncryptionKeyHash() async {
    final encryptionKey = await readEncryptionKey();
    return encryptionKey == null
        ? null
        : sha256
            .convert(utf8.encode(
              encryptionKey,
            ))
            .toString();
  }

  Future<void> writeEncryptionKey(String? key) async {
    if (key == null) {
      // If key is null, set backup encryption status as false and remove key
      await SharedPreferencesAsync().setBool(backupEncryptionStatus, false);
      await SharedPreferencesAsync().remove(lastUpdateTimeKey);
    } else {
      // set status as true and encryption key
      await SharedPreferencesAsync().setBool(backupEncryptionStatus, true);
      await SharedPreferencesAsync().setString(lastUpdateTimeKey, key);
    }
  }

  Future<List<int>> extractDbArchive() async {
    final password = await readEncryptionKey();
    final string = await extractDbJson();
    final encoder = ZipEncoder(password: password);
    final archive = Archive();
    archive.add(ArchiveFile.string(dbExportJsonName, string));
    final encoded = encoder.encode(
      archive,
      level: DeflateLevel.bestCompression,
      autoClose: true,
    );
    return encoded;
  }

  Future<void> archiveToDb(List<int> archiveEncoded) async {
    final password = await readEncryptionKey();
    final decoder = ZipDecoder();
    final archive =
        decoder.decodeBytes(archiveEncoded.toList(), password: password);
    final file = archive.findFile(dbExportJsonName);
    if (file == null) {
      throw ArchiveException("Invalid archive, no valid file found in the zip");
    }
    final byteContent = file.readBytes();
    if (byteContent == null) {
      throw ArchiveException(
          "Invalid archive, content of file in archive is empty");
    }
    final content = String.fromCharCodes(byteContent);
    await jsonToDb(content);
  }

  Future<void> updateLastUpdatedTime() async {
    await SharedPreferencesAsync().setString(
        lastUpdateTimeKey, DateTime.now().millisecondsSinceEpoch.toString());
  }

  Future<DateTime> getLastUpdatedTime() async {
    final lastTime =
        await SharedPreferencesAsync().getString(lastUpdateTimeKey);
    if (lastTime == null) {
      return DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(int.parse(lastTime));
  }
}

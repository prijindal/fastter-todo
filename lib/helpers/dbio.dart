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
    final entries = await MyDatabase.instance.managers.todo.get();
    String encoded = jsonEncode(
      {
        "entries": entries,
      },
    );
    AppLogger.instance.i("Extracted data from database");
    return encoded;
  }

  Future<void> jsonToDb(String jsonEncoded) async {
    final decoded = jsonDecode(jsonEncoded);
    List<dynamic> entries = decoded["entries"] as List<dynamic>;
    await MyDatabase.instance.batch((batch) {
      batch.insertAll(
        MyDatabase.instance.todo,
        entries.map(
          (a) {
            // Workaround to make it so that the document in json is properly inserted back to db
            a["tags"] = (a["tags"] as List<dynamic>)
                .map<String>((a) => a as String)
                .toList();
            a["updationTime"] = (a["updationTime"] ?? DateTime.now());
            a["creationTime"] = (a["creationTime"] ?? DateTime.now());
            a["hidden"] = (a["hidden"] ?? false);
            return TodoData.fromJson(a as Map<String, dynamic>);
          },
        ),
        mode: InsertMode.insertOrIgnore,
      );
    });
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
      return SharedPreferencesAsync().getString(backupEncryptionKey);
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
      await SharedPreferencesAsync().remove(backupEncryptionKey);
    } else {
      // set status as true and encryption key
      await SharedPreferencesAsync().setBool(backupEncryptionStatus, true);
      await SharedPreferencesAsync().setString(backupEncryptionKey, key);
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

  Future<DateTime> getLastUpdatedTime() async {
    final lastUpdatedRows = await (MyDatabase.instance.todo.select()
          ..limit(1)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.creationTime,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();
    if (lastUpdatedRows.isEmpty) {
      return DateTime.now();
    }
    final lastUpdatedTime = lastUpdatedRows.first.creationTime;
    return lastUpdatedTime;
  }
}

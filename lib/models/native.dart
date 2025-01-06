// native.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../helpers/constants.dart';
import '../helpers/logger.dart';
import "./core.dart";

SharedDatabase constructDb() {
  final db = LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final path = p.join(dbFolder.path, dbFileName);
    AppLogger.instance.d("Db Path: $path");
    final file = File(path);
    return NativeDatabase(file);
  });
  return SharedDatabase(db);
}

import 'dart:convert';
import 'dart:io';

import 'package:download/download.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/db_manager.dart';
import 'constants.dart';

void downloadContent(BuildContext context) async {
  final encoded = await GetIt.I<DbManager>().io.extractDbJson();
  if (Platform.isAndroid || Platform.isIOS) {
    final params = SaveFileDialogParams(
      data: Uint8List.fromList(encoded.codeUnits),
      fileName: dbExportJsonName,
    );
    final filePath = await FlutterFileDialog.saveFile(params: params);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Content saved at $filePath"),
        ),
      );
    }
    return;
  } else {
    String downloadDirectory = "";
    if (!kIsWeb) {
      final downloadFolder = await getDownloadsDirectory();
      if (downloadFolder != null) {
        downloadDirectory = downloadFolder.path;
      }
    }
    final path = p.join(downloadDirectory, dbExportJsonName);
    final stream = Stream.fromIterable(encoded.codeUnits);
    await download(stream, path);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Content downloaded as $path"),
        ),
      );
    }
  }
}

void uploadContent(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    String? jsonEncoded;
    if (result.files.single.bytes != null) {
      jsonEncoded = utf8.decode(result.files.single.bytes!);
    } else if (result.files.single.path != null) {
      jsonEncoded = await File(result.files.single.path!).readAsString();
    }
    if (jsonEncoded != null && context.mounted) {
      try {
        await GetIt.I<DbManager>().io.jsonToDb(jsonEncoded);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Successfully imported"),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Error while syncing",
              ),
            ),
          );
        }
      }
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cancelled file upload"),
        ),
      );
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../helpers/constants.dart'
    show dbExportArchiveName, dbLastUpdatedName;
import '../../../helpers/dbio.dart';
import '../../../helpers/logger.dart';

class SyncMetadata {
  final DateTime lastUpdatedAt;
  final String? encryptedKeyHash;

  SyncMetadata({
    required this.lastUpdatedAt,
    this.encryptedKeyHash,
  });

  Map<String, dynamic> toJson() => {
        'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
        'encryptedKeyHash': encryptedKeyHash,
      };

  factory SyncMetadata.fromJson(dynamic json) => SyncMetadata(
        lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
        encryptedKeyHash: json['encryptedKeyHash'] as String?,
      );

  @override
  String toString() =>
      'SyncMetadata(lastUpdatedAt: $lastUpdatedAt, encryptedKeyHash: $encryptedKeyHash)';
}

enum SyncStatus {
  waiting("Waiting for init"),
  metadataLoading("Metadata Loading"),
  metadataSynced("Metadata Synced"),
  syncing("Syncing"),
  syncFailed("Sync failed"),
  syncDone("Sync done");

  const SyncStatus(this.title);
  final String title;
}

enum SyncReason {
  unknown(false, "Some error occurred"),
  unsupported(false, "Platform is not supported"),
  notFound(false, "File not found"),
  signedOut(false, "User is not signed in"),
  encryptionKeyMismatch(false, "Encryption keys are mismatched"),

  uploaded(true, "File uploaded successfully"),
  downloaded(true, "File downloaded successfully"),
  alreadySynced(true, "Latest already synced");

  const SyncReason(this.status, this.title);
  final bool status; // true means sync success, false means false
  final String title;
}

// U: User definition
abstract class SyncBase<U> with ChangeNotifier {
  SyncStatus _syncStatus = SyncStatus.waiting;
  SyncMetadata? _syncMetadata;
  final DatabaseIO Function() _ioGetter;

  SyncBase(DatabaseIO Function() ioGetter) : _ioGetter = ioGetter;

  DatabaseIO get io => _ioGetter();

  U? get currentUser;
  bool get isSupported => throw UnimplementedError();
  SyncStatus get syncStatus => _syncStatus;
  SyncMetadata? get metadata => _syncMetadata;
  Future<void> checkSignIn();
  Future<void> signOut();

  Future<List<int>?> getFile(String fileName);
  Future<void> uploadFile(String filename, List<int> localData);

  Future<void> syncLastUpdatedAt() async {
    _syncStatus = SyncStatus.metadataLoading;
    notifyListeners();
    final bytes = await getFile(dbLastUpdatedName);
    if (bytes != null) {
      _syncMetadata =
          SyncMetadata.fromJson(jsonDecode(String.fromCharCodes(bytes)));
    }
    _syncStatus = SyncStatus.metadataSynced;
    notifyListeners();
  }

  Future<void> _upload() async {
    await uploadFile(dbExportArchiveName, await io.extractDbArchive());
    final lastUpdatedTime = await io.getLastUpdatedTime();
    final encryptionKeyHash = await io.readEncryptionKeyHash();
    final metadata = SyncMetadata(
      lastUpdatedAt: lastUpdatedTime,
      encryptedKeyHash: encryptionKeyHash,
    );
    await uploadFile(
      dbLastUpdatedName,
      jsonEncode(metadata.toJson()).codeUnits,
    );
    _syncMetadata = metadata;
    notifyListeners();
  }

  Future<SyncReason> _download() async {
    await syncLastUpdatedAt();
    if (_syncMetadata == null) {
      return SyncReason.notFound;
    }
    final fileContent = await getFile(dbExportArchiveName);
    if (fileContent == null) {
      return SyncReason.notFound;
    }
    final currentEncryptionHash = await io.readEncryptionKeyHash();
    if (_syncMetadata!.encryptedKeyHash != currentEncryptionHash) {
      return SyncReason.encryptionKeyMismatch;
    }
    await io.archiveToDb(fileContent);
    return SyncReason.downloaded;
  }

  Future<SyncReason> _sync() async {
    _syncStatus = SyncStatus.syncing;
    notifyListeners();
    if (!isSupported) {
      _syncStatus = SyncStatus.syncFailed;
      notifyListeners();
      return SyncReason.unsupported;
    }
    await checkSignIn();
    if (currentUser == null) {
      _syncStatus = SyncStatus.syncFailed;
      notifyListeners();
      return SyncReason.signedOut;
    }
    await syncLastUpdatedAt();
    if (metadata == null) {
      await _upload();
      _syncStatus = SyncStatus.syncDone;
      notifyListeners();
      return SyncReason.uploaded;
    } else {
      final lastUpdatedTimeLocal = await io.getLastUpdatedTime();
      SyncReason reason = SyncReason.unknown;
      if (lastUpdatedTimeLocal.compareTo(_syncMetadata!.lastUpdatedAt) == 0) {
        reason = SyncReason.alreadySynced;
      } else if (lastUpdatedTimeLocal.compareTo(_syncMetadata!.lastUpdatedAt) >
          0) {
        _upload();
        reason = SyncReason.uploaded;
      } else {
        final currentEncryptionHash = await io.readEncryptionKeyHash();
        if (_syncMetadata!.encryptedKeyHash != currentEncryptionHash) {
          return SyncReason.encryptionKeyMismatch;
        }
        _download();
        reason = SyncReason.downloaded;
      }
      _syncStatus = SyncStatus.syncDone;
      notifyListeners();
      return reason;
    }
  }

  Future<void> upload(BuildContext context) async {
    try {
      await _upload();
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(SyncReason.uploaded.title),
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.instance.e(e, error: e, stackTrace: stackTrace);
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(SyncReason.unknown.title),
          ),
        );
      }
      rethrow;
    }
  }

  Future<void> download(BuildContext context) async {
    try {
      final status = await _download();
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status.title,
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.instance.e(e, error: e, stackTrace: stackTrace);
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(SyncReason.unknown.title),
          ),
        );
      }
      rethrow;
    }
  }

  Future<bool> sync(ScaffoldMessengerState? scaffoldMessengerState,
      {bool suppressErrors = false}) async {
    try {
      final syncReason = await _sync();
      if (scaffoldMessengerState != null) {
        AppLogger.instance.i(syncReason.title);
        if (syncReason.status == false && suppressErrors == true) {
          return false;
        }
        // ignore: use_build_context_synchronously
        scaffoldMessengerState.showSnackBar(
          SnackBar(
            content: Text(syncReason.title),
          ),
        );
      }
      return syncReason.status;
    } catch (e, stackTrace) {
      AppLogger.instance.e(e, error: e, stackTrace: stackTrace);
      if (scaffoldMessengerState != null) {
        // ignore: use_build_context_synchronously
        scaffoldMessengerState.showSnackBar(
          SnackBar(
            content: Text(SyncReason.unknown.title),
          ),
        );
      }
      rethrow;
    }
  }
}

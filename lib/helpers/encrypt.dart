import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'flutter_persistor.dart';

const String ENCRYPTION_KEY = "ENCRYPTION_KEY";

class EncryptionService {
  String _encryptionKey;
  Map<String, String> _cacheEncrypted = {};
  Map<String, String> _cacheDecrypted = {};

  static EncryptionService _instance;

  static EncryptionService getInstance() {
    if (_instance == null) {
      _instance = EncryptionService();
    }
    return _instance;
  }

  String get encryptionKey {
    if (_encryptionKey == null) {
      this._encryptionKey =
          FlutterPersistor.getInstance().loadString(ENCRYPTION_KEY);
    }
    if (this._encryptionKey == null || this._encryptionKey.isEmpty) {
      return null;
    }
    return this._encryptionKey;
  }

  void setEncryptionKey(String encryptionKey, bool shouldSave) {
    this._encryptionKey = md5.convert(utf8.encode(encryptionKey)).toString();
    _cacheDecrypted = {};
    _cacheEncrypted = {};
    if (shouldSave) {
      FlutterPersistor.getInstance()
          .setString(ENCRYPTION_KEY, this._encryptionKey);
    }
  }

  void deleteEncryptionKey() {
    this._encryptionKey = null;
    FlutterPersistor.getInstance().clearString(ENCRYPTION_KEY);
  }

  Encrypter getEncryptor() {
    if (encryptionKey == null) {
      return null;
    }
    final key = Key.fromUtf8(encryptionKey);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter;
  }

  String encrypt(String decryptedText) {
    if (_cacheEncrypted.containsKey(decryptedText)) {
      return _cacheDecrypted[decryptedText];
    }
    final iv = IV.fromLength(16);
    final encryptedText = getEncryptor().encrypt(decryptedText, iv: iv).base64;
    final transitmessage = iv.base64 + encryptedText;
    _cacheDecrypted[decryptedText] = transitmessage;
    return transitmessage;
  }

  String decrypt(String transitmessage) {
    if (_cacheDecrypted.containsKey(transitmessage)) {
      return _cacheDecrypted[transitmessage];
    }
    final iv = IV.fromBase64(transitmessage.substring(0, 24));
    final encryptedText = transitmessage.substring(24);
    final encryptedContent = Encrypted.fromBase64(encryptedText);
    final encryptor = getEncryptor();
    if (encryptor == null) {
      return '';
    }
    try {
      final decryptedText = encryptor.decrypt(encryptedContent, iv: iv);
      _cacheDecrypted[encryptedText] = decryptedText;
      return decryptedText;
    } catch (error) {
      rethrow;
    }
  }
}

import 'dart:async';
import 'dart:typed_data';

import '../../../../firebase/firebase_init.dart';
import '../../../../helpers/logger.dart';
import '../../components/sync.dart';

class FirebaseSync extends SyncBase<User> {
  User? _user;
  StreamSubscription<User?>? _subscription;

  FirebaseSync(super.ioGetter) {
    AppLogger.instance.d("Registering subscription");
    if (isSupported) {
      _subscription = FirebaseAuth.instance.authStateChanges().listen((user) {
        AppLogger.instance.d("Signed in");
        _user = user;
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  bool get isSupported => Firebase.apps.isNotEmpty;

  @override
  User? get currentUser => _user;

  @override
  Future<void> signOut() => FirebaseAuth.instance.signOut();

  @override
  Future<void> checkSignIn() async {
    AppLogger.instance.d("Checking sign in");
    if (currentUser != null) {
      syncLastUpdatedAt();
    }
  }

  @override
  Future<List<int>?> getFile(String fileName) async {
    if (currentUser == null) return null;
    final ref = FirebaseStorage.instance.ref("${currentUser!.uid}/$fileName");
    try {
      final dbBytes = await ref.getData();
      return dbBytes;
    } on FirebaseException catch (e) {
      if (e.code == "object-not-found") {
        return null;
      } else {
        AppLogger.instance.e(e.message);
        rethrow;
      }
    }
  }

  @override
  Future<void> uploadFile(String filename, List<int> localData) async {
    if (currentUser == null) return;
    final ref = FirebaseStorage.instance.ref("${currentUser!.uid}/$filename");
    await ref.putData(Uint8List.fromList(localData));
  }
}

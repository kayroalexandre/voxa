
import 'dart:io';
import 'dart:developer' as developer;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> uploadFile(String filePath, String destination) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final file = File(filePath);
    try {
      final ref = _storage.ref(destination);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e, s) {
      developer.log(
        'Error uploading file',
        name: 'voxa.storage',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voxa/features/storage/storage_service.dart';
import 'package:voxa/features/mind_maps/mind_map_model.dart';

class MindMapService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageService _storageService = StorageService();

  Future<void> createMindMap(String title, List<MindMapNode> nodes) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('mindMaps')
          .add({
        'title': title,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'nodes': nodes.map((node) => node.toMap()).toList(),
        'files': [],
      });
    }
  }

  Stream<List<MindMap>> getMindMaps() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('mindMaps')
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => MindMap.fromFirestore(doc)).toList());
    } else {
      return Stream.value([]);
    }
  }

  Future<void> addFileToMindMap(String mindMapId, String filePath) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final fileName = filePath.split('/').last;
    final destination = 'mindMaps/${user.uid}/$fileName';

    final storagePath = await _storageService.uploadFile(filePath, destination);

    if (storagePath != null) {
      final mindMapRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('mindMaps')
          .doc(mindMapId);

      final newFile = MindMapFile(
        fileName: fileName,
        storagePath: storagePath,
        createdAt: Timestamp.now(),
      );

      await mindMapRef.update({
        'files': FieldValue.arrayUnion([newFile.toMap()]),
      });
    }
  }
}

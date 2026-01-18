
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voxa/features/mind_maps/mind_map_model.dart';

class MindMapService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
}

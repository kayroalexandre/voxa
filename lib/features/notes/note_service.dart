
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'note_model.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createNote(String text, String source) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notes')
          .add({
        'text': text,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'source': source,
      });
    }
  }

  Stream<List<Note>> getNotes() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notes')
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList());
    } else {
      return Stream.value([]);
    }
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'journal_model.dart';

class JournalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createJournal(String text) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('journals')
          .add({
        'text': text,
        'startedAt': Timestamp.now(),
        'finishedAt': Timestamp.now(),
        'createdAt': Timestamp.now(),
        'aiSummary': null,
      });
    }
  }

  Stream<List<Journal>> getJournals() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('journals')
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Journal.fromFirestore(doc)).toList());
    } else {
      return Stream.value([]);
    }
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';

class Journal {
  final String id;
  final String text;
  final Timestamp startedAt;
  final Timestamp finishedAt;
  final Timestamp createdAt;
  final String? aiSummary;

  Journal({
    required this.id,
    required this.text,
    required this.startedAt,
    required this.finishedAt,
    required this.createdAt,
    this.aiSummary,
  });

  factory Journal.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Journal(
      id: doc.id,
      text: data['text'] ?? '',
      startedAt: data['startedAt'] ?? Timestamp.now(),
      finishedAt: data['finishedAt'] ?? Timestamp.now(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      aiSummary: data['aiSummary'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'startedAt': startedAt,
      'finishedAt': finishedAt,
      'createdAt': createdAt,
      'aiSummary': aiSummary,
    };
  }
}

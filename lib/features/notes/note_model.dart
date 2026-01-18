
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String text;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String source;

  Note({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.source,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      text: data['text'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
      source: data['source'] ?? 'text',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'source': source,
    };
  }
}

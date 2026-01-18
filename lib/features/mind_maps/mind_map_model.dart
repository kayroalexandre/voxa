
import 'package:cloud_firestore/cloud_firestore.dart';

class MindMapFile {
  final String fileName;
  final String storagePath;
  final Timestamp createdAt;

  MindMapFile({
    required this.fileName,
    required this.storagePath,
    required this.createdAt,
  });

  factory MindMapFile.fromMap(Map<String, dynamic> map) {
    return MindMapFile(
      fileName: map['fileName'] ?? '',
      storagePath: map['storagePath'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'storagePath': storagePath,
      'createdAt': createdAt,
    };
  }
}

class MindMap {
  final String id;
  final String title;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final List<MindMapNode> nodes;
  final List<MindMapFile> files;

  MindMap({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.nodes,
    required this.files,
  });

  factory MindMap.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return MindMap(
      id: doc.id,
      title: data['title'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
      nodes: (data['nodes'] as List? ?? [])
          .map((node) => MindMapNode.fromMap(node))
          .toList(),
      files: (data['files'] as List? ?? [])
          .map((file) => MindMapFile.fromMap(file))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'nodes': nodes.map((node) => node.toMap()).toList(),
      'files': files.map((file) => file.toMap()).toList(),
    };
  }
}

class MindMapNode {
  final String id;
  final String text;
  final List<String> childrenIds;

  MindMapNode({
    required this.id,
    required this.text,
    required this.childrenIds,
  });

  factory MindMapNode.fromMap(Map<String, dynamic> map) {
    return MindMapNode(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      childrenIds: List<String>.from(map['childrenIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'childrenIds': childrenIds,
    };
  }
}

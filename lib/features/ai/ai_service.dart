
import 'dart:io';
import 'dart:developer' as developer;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voxa/features/mind_maps/mind_map_model.dart';

class AiService {
  final FirebaseAI _vertexAI = FirebaseAI.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'us-central1');

  Future<String> enhanceText(String text) async {
    try {
      final callable = _functions.httpsCallable('enhanceText');
      final result = await callable.call<Map<String, dynamic>>({
        'text': text,
      });
      return result.data['enhancedText'] as String? ?? 'Could not enhance text.';
    } on FirebaseFunctionsException catch (e) {
      developer.log(
        'Error calling enhanceText Cloud Function',
        name: 'voxa.ai_service',
        error: e.code,
        stackTrace: StackTrace.current,
      );
      return 'Error: ${e.message}';
    } catch (e) {
      developer.log(
        'An unexpected error occurred in enhanceText',
        name: 'voxa.ai_service',
        error: e,
        stackTrace: StackTrace.current,
      );
      return 'An unexpected error occurred.';
    }
  }

  Future<String> summarizeMindMap(MindMap mindMap) async {
    final model = _vertexAI.generativeModel(model: 'gemini-1.5-flash');

    final prompt = await _buildPrompt(mindMap);

    final response = await model.generateContent([Content.text(prompt)]);

    return response.text ?? 'Could not generate summary.';
  }

  Future<String> _buildPrompt(MindMap mindMap) async {
    final buffer = StringBuffer();

    buffer.writeln('Summarize the following mind map:');
    buffer.writeln('Title: ${mindMap.title}');

    if (mindMap.nodes.isNotEmpty) {
      buffer.writeln('Nodes:');
      for (final node in mindMap.nodes) {
        buffer.writeln('- ${node.text}');
      }
    }

    if (mindMap.files.isNotEmpty) {
      buffer.writeln('Attached Files Content:');
      for (final file in mindMap.files) {
        try {
          final content = await _downloadAndReadFile(file.storagePath);
          buffer.writeln('File: ${file.fileName}');
          buffer.writeln(content);
        } catch (e, s) {
          developer.log(
            'Could not read file: ${file.fileName}',
            name: 'voxa.ai_service',
            error: e,
            stackTrace: s,
          );
          buffer.writeln('Could not read file: ${file.fileName}');
        }
      }
    }

    return buffer.toString();
  }

  Future<String> _downloadAndReadFile(String storagePath) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${storagePath.split('/').last}';
    final file = File(filePath);

    try {
      await _storage.ref(storagePath).writeToFile(file);
      return await file.readAsString();
    } finally {
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}

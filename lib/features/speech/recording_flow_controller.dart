
import 'package:voxa/features/speech/transcription_service.dart';

class RecordingFlowController {
  final TranscriptionService _transcriptionService = TranscriptionService();

  Future<String> processRecording(String audioPath) async {
    print('[Controller] Starting flow for: $audioPath');
    try {
      final String rawText = await _transcriptionService.transcribe(audioPath);
      print('[Controller] Raw text received: "$rawText"');
      return rawText;
    } catch (e) {
      print('[Controller] [ERROR] Recording flow failed: $e');
      rethrow;
    }
  }
}

import 'package:voxa/features/ai/text_enhancement_service.dart';
import 'package:voxa/features/speech/transcription_service.dart';

class RecordingFlowController {
  final TranscriptionService _transcriptionService = TranscriptionService();
  final TextEnhancementService _textEnhancementService = TextEnhancementService();

  /// Orchestrates the process after a voice recording is completed.
  ///
  /// 1. Transcribes the audio file to get the raw text.
  /// 2. Sends the raw text to the AI service for correction.
  /// 3. Returns the final, enhanced text.
  Future<String> processRecording(String audioPath) async {
    print('[Controller] Iniciando o fluxo para: $audioPath');
    try {
      // Etapa 1: Transcrição (ainda irá lançar UnimplementedError)
      final String rawText = await _transcriptionService.transcribe(audioPath);
      print('[Controller] Texto bruto recebido: "$rawText"');

      // Etapa 2: Correção com IA
      final String enhancedText = await _textEnhancementService.enhance(rawText);
      print('[Controller] Texto corrigido pela IA: "$enhancedText"');

      return enhancedText;
    } catch (e) {
      print('[Controller] [ERRO] Falha no fluxo de gravação: $e');
      // Re-lança a exceção para ser tratada pela camada de UI (HomeScreen)
      rethrow;
    }
  }
}

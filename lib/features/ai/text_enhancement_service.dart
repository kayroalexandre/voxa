import 'package:cloud_functions/cloud_functions.dart';

class TextEnhancementService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Calls the `enhanceText` Cloud Function to correct the provided raw text.
  Future<String> enhance(String rawText) async {
    if (rawText.trim().isEmpty) {
      return rawText;
    }

    try {
      final HttpsCallable callable = _functions.httpsCallable('enhanceText');
      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'text': rawText,
      });

      final enhancedText = result.data['enhancedText'] as String?;

      if (enhancedText == null) {
        throw Exception('A resposta da função de IA não continha o texto corrigido.');
      }

      return enhancedText;
    } on FirebaseFunctionsException catch (e) {
      print("FirebaseFunctionsException on enhance: ${e.code} - ${e.message}");
      // Re-throw a more specific exception for the controller to handle.
      throw Exception('Falha ao comunicar com o serviço de IA. Código: ${e.code}');
    } catch (e) {
      print("Generic Exception on enhance: $e");
      // Re-throw for the controller.
      rethrow;
    }
  }
}

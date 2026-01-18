
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:developer' as developer;

class AiService {
  final FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'us-central1');

  /// Corrige e aprimora um texto mantendo o sentido original
  Future<String> enhanceText(String text) async {
    try {
      final callable = _functions.httpsCallable('enhanceText');

      final result = await callable.call<Map<String, dynamic>>({
        'text': text,
      });

      return result.data['enhancedText'] as String? ?? 'Could not enhance text.';
    } on FirebaseFunctionsException catch (e, s) {
      developer.log(
        'Error calling enhanceText',
        name: 'voxa.ai_service',
        error: e,
        stackTrace: s,
      );
      return 'Error: ${e.message}';
    } catch (e, s) {
      developer.log(
        'An unexpected error occurred in enhanceText',
        name: 'voxa.ai_service',
        error: e,
        stackTrace: s,
      );
      return 'An unexpected error occurred.';
    }
  }

  /// Gera um resumo conciso a partir de um mapa mental.
  Future<String> summarizeMindMap(String mindMapId) async {
    try {
      final callable = _functions.httpsCallable('summarizeMindMap');
      final result = await callable.call<Map<String, dynamic>>({
        'mindMapId': mindMapId,
      });
      return result.data['summary'] as String? ?? 'Could not generate summary.';
    } on FirebaseFunctionsException catch (e, s) {
      developer.log(
        'Error calling summarizeMindMap',
        name: 'voxa.ai_service',
        error: e,
        stackTrace: s,
      );
      return 'Error: ${e.message}';
    } catch (e, s) {
      developer.log(
        'An unexpected error occurred in summarizeMindMap',
        name: 'voxa.ai_service',
        error: e,
        stackTrace: s,
      );
      return 'An unexpected error occurred.';
    }
  }
}


import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:developer' as developer;

class SpeechService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  bool get isListening => _isListening;

  Future<void> initialize() async {
    try {
      _isInitialized = await _speechToText.initialize(
        onError: (error) => developer.log('Speech recognition error: $error', name: 'voxa.speech_service'),
        onStatus: (status) => _handleStatusChange(status),
      );
    } catch (e, s) {
        developer.log(
          'Error initializing speech to text',
          name: 'voxa.speech_service',
          error: e,
          stackTrace: s,
        );
    }

  }

  void _handleStatusChange(String status) {
    _isListening = _speechToText.isListening;
    developer.log('Speech recognition status: $status', name: 'voxa.speech_service');
  }

  void startListening(Function(String) onResult) {
    if (!_isInitialized) {
      developer.log('Speech service not initialized', name: 'voxa.speech_service');
      return;
    }
    if (_isListening) {
       developer.log('Already listening', name: 'voxa.speech_service');
      return;
    }

    try {
       _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          onResult(result.recognizedWords);
        },
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
      );
    } catch (e,s) {
       developer.log(
        'Error starting to listen',
        name: 'voxa.speech_service',
        error: e,
        stackTrace: s,
      );
    }
  }

  void stopListening() {
     if (!_isListening) {
       developer.log('Not currently listening', name: 'voxa.speech_service');
      return;
    }
    try {
      _speechToText.stop();
    } catch (e,s) {
      developer.log(
        'Error stopping listening',
        name: 'voxa.speech_service',
        error: e,
        stackTrace: s,
      );
    }
  }

  void dispose() {
    _speechToText.stop();
  }
}

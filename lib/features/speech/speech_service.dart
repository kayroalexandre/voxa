
import 'dart:async';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class SpeechService {
  final AudioRecorder _audioRecorder = AudioRecorder();

  /// Initializes the speech service by requesting microphone permission.
  Future<void> initialize() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }
  }

  /// Starts recording audio.
  ///
  /// The recording is saved to a temporary file in .m4a format.
  Future<void> startRecording() async {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/voxa_recording.m4a';
    
    // Using aacLc encoder for .m4a file format which is broadly compatible.
    const config = RecordConfig(encoder: AudioEncoder.aacLc);

    // Start recording to the specified path.
    await _audioRecorder.start(config, path: path);
  }

  /// Stops the audio recording and returns the path to the recorded file.
  Future<String?> stopRecording() async {
    final path = await _audioRecorder.stop();
    return path;
  }

  /// Returns a stream of amplitude values.
  Stream<Amplitude> onAmplitudeChanged(Duration interval) {
    return _audioRecorder.onAmplitudeChanged(interval);
  }
}

import 'package:flutter/material.dart';
import 'package:voxa/features/speech/recording_flow_controller.dart';
import 'package:voxa/features/speech/voice_recording_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecordingFlowController _recordingFlowController = RecordingFlowController();

  void _handleRecordingCompleted(String audioPath) async {
    print('[HomeScreen] Received audio path: $audioPath');
    try {
      final String rawText = await _recordingFlowController.processRecording(audioPath);
      // As per instructions, the raw text is only available internally for now.
      print('[HomeScreen] [INTERNAL] Raw transcription result: "$rawText"');
    } catch (e) {
      // This will catch the UnimplementedError from the TranscriptionService.
      print('[HomeScreen] [ERROR] Could not process recording: $e');
      if (mounted) {
        // Optionally, inform the user that the feature is not ready.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voxa'),
      ),
      body: const Center(
        child: Text('Welcome to Voxa!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            builder: (context) => const VoiceRecordingSheet(),
          ).then((audioPath) {
            if (audioPath != null && audioPath.isNotEmpty) {
              _handleRecordingCompleted(audioPath);
            }
          });
        },
        child: const Icon(Icons.mic),
      ),
    );
  }
}

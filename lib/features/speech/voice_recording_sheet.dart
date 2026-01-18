import 'package:flutter/material.dart';
import 'package:voxa/features/speech/speech_service.dart';
import 'dart:math';

class VoiceRecordingSheet extends StatefulWidget {
  const VoiceRecordingSheet({super.key});

  @override
  State<VoiceRecordingSheet> createState() => _VoiceRecordingSheetState();
}

class _VoiceRecordingSheetState extends State<VoiceRecordingSheet>
    with SingleTickerProviderStateMixin {
  final SpeechService _speechService = SpeechService();
  AnimationController? _controller;
  bool _isStopping = false;

  @override
  void initState() {
    super.initState();
    _initializeAndStartRecording();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0.1,
      upperBound: 0.5,
    )..repeat(reverse: true);
  }

  Future<void> _initializeAndStartRecording() async {
    try {
      await _speechService.initialize();
      await _speechService.startRecording();
    } catch (e) {
      if (mounted) {
        // Show a generic error if permission is denied
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission not granted.')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    // Only stop and discard if it wasn't already stopped by the confirm button
    if (!_isStopping) {
      _speechService.stopRecording();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Recording...",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          AnimatedBuilder(
            animation: _controller!,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(
                  Theme.of(context).colorScheme.primary,
                  _controller?.value ?? 0.1, // Use simulated value from controller
                ),
                child: const SizedBox(
                  height: 100,
                  width: double.infinity,
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red.shade800,
                ),
                onPressed: () {
                  // _isStopping remains false, so dispose() will handle the stop/discard.
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.close, size: 30),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.green.shade100,
                  foregroundColor: Colors.green.shade800,
                ),
                onPressed: () async {
                  _isStopping = true; // Prevents dispose from stopping again
                  final path = await _speechService.stopRecording();
                  if (mounted) {
                    Navigator.of(context).pop(path);
                  }
                },
                child: const Icon(Icons.check, size: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;
  final double amplitude; // This is now a simulated value (0.1 to 0.5)

  WavePainter(this.color, this.amplitude);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();
    final waveHeight = size.height / 2;
    final waveAmplitude = waveHeight * amplitude;

    path.moveTo(0, waveHeight);

    for (double i = 0; i < size.width; i++) {
      // Create a simple pulsing sine wave effect
      final y = waveHeight + waveAmplitude * sin((i / size.width) * 4 * pi);
      path.lineTo(i, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) =>
      oldDelegate.amplitude != amplitude || oldDelegate.color != color;
}

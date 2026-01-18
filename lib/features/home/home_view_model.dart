import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier {
  bool _isListening = false;

  bool get isListening => _isListening;

  void toggleListening() {
    _isListening = !_isListening;
    notifyListeners();
  }
}

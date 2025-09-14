import 'package:flutter/material.dart';

class DebugConsole extends ChangeNotifier {
  final List<String> _logs = [];

  List<String> get logs => List.unmodifiable(_logs);

  void add(String message) {
    final timestamp = DateTime.now().toIso8601String();
    _logs.insert(0, "[$timestamp] $message");
    notifyListeners();
  }
}

final debugConsole = DebugConsole();

import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/features/debug_service/debug_service.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📋 Debug Console")),
      body: AnimatedBuilder(
        animation: debugConsole,
        builder: (context, _) {
          return ListView.builder(
            itemCount: debugConsole.logs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(debugConsole.logs[index]),
              );
            },
          );
        },
      ),
    );
  }
}

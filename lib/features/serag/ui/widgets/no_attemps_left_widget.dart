import 'package:flutter/material.dart';

class NoAttemptsLeftWidget extends StatelessWidget {
  const NoAttemptsLeftWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "عذراً، لقد استنفذت الحد اليومي.\nيرجى المحاولة مرة أخرى غداً.",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

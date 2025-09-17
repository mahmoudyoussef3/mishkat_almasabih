import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class DialogHeader extends StatelessWidget {
  final String title;
  const DialogHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                ColorsManager.primaryPurple,
                ColorsManager.secondaryPurple,
              ],
            ),
          ),
          child: const Icon(Icons.bookmark, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: ColorsManager.primaryText,
          ),
        ),
      ],
    );
  }
}

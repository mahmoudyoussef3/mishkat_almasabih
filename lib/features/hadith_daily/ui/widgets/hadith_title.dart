import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class HadithTitle extends StatelessWidget {
  final String title;
  const HadithTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: ColorsManager.primaryPurple,
      ),
      textAlign: TextAlign.center,
    );
  }
}

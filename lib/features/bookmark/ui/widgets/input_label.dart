import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class InputLabel extends StatelessWidget {
  final String label;
  const InputLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        label,
        style: const TextStyle(
          color: ColorsManager.secondaryText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}



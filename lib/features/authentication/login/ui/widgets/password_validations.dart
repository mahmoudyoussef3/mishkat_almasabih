import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';

class PasswordValidations extends StatelessWidget {
  final bool hasLowerCase;
  final bool hasUpperCase;
  final bool hasSpecialCharacters;
  final bool hasNumber;
  final bool hasMinLength;
  const PasswordValidations({
    required this.hasLowerCase, required this.hasUpperCase, required this.hasSpecialCharacters, required this.hasNumber, required this.hasMinLength, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildValidationRow('At least 1 lowercase letter', hasLowerCase),
        const SizedBox(height: 2),
        buildValidationRow('At least 1 uppercase letter', hasUpperCase),
        const SizedBox(height: 2),
        buildValidationRow(
          'At least 1 special character',
          hasSpecialCharacters,
        ),
        const SizedBox(height: 2),
        buildValidationRow('At least 1 number', hasNumber),
        const SizedBox(height: 2),
        buildValidationRow('At least 8 characters long', hasMinLength),
      ],
    );
  }

  Widget buildValidationRow(String text, bool hasValidated) {
    return Row(
      children: [
        const CircleAvatar(radius: 2.5, backgroundColor: ColorsManager.gray),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyles.font13DarkBlueRegular.copyWith(
            decoration: hasValidated ? TextDecoration.lineThrough : null,
            decorationColor: Colors.green,
            decorationThickness: 2,
            color: hasValidated ? ColorsManager.gray : ColorsManager.darkBlue,
          ),
        ),
      ],
    );
  }
}

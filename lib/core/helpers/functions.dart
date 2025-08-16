import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import '../theming/styles.dart';

void setupErrorState(BuildContext context, String error) {
  context.pop();
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: Colors.white,
          icon: const Icon(Icons.error, color: Colors.red, size: 32),
          content: Text(error, style: TextStyles.font15DarkBlueMedium),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text('حسنا', style: TextStyles.font14BlueSemiBold),
            ),
          ],
        ),
  );
}

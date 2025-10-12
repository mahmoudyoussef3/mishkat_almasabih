import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

void showBookmarkSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: ColorsManager.hadithAuthentic,
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: TextStyle(color: ColorsManager.secondaryBackground),
      ),
    ),
  );
}

void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: TextStyle(color: ColorsManager.secondaryBackground),
      ),
    ),
  );
}

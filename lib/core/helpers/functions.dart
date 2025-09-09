import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
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
  Color getGradeColor(String? g) {
    switch (g?.toLowerCase()) {
      case "sahih":
      case "صحيح":
        return ColorsManager.hadithAuthentic;
      case "hasan":
      case "حسن":
        return ColorsManager.hadithGood;
      case "daif":
      case "ضعيف":
        return ColorsManager.hadithWeak;
      default:
        return ColorsManager.hadithAuthentic;
    }
    
  }
  void showToast(String msg, Color? color) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 8,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}
String convertToArabicNumber(int number) {
  const englishToArabic = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  String english = number.toString();
  String arabic = english.split('').map((digit) => englishToArabic[digit] ?? digit).join();
  return arabic;
}
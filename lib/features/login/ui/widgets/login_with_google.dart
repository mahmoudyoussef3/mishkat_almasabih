import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            //  border: Border.all(color: ColorsManager.primaryGreen),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  'تسجيل الدخول عبر جوجل',
                  style: TextStyle(color: ColorsManager.darkGray),
                ),
                Icon(Icons.apple, color: ColorsManager.darkGray),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

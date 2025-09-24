import 'package:flutter/material.dart';

class HadithRichText extends StatelessWidget {
  final String hadith;

  const HadithRichText({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: hadith,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "Amiri",
              height: 1.8,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

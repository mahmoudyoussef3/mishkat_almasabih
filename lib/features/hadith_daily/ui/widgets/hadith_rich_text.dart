import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class HadithRichText extends StatelessWidget {
  final String hadith;
  final List wordsMeanings;

  const HadithRichText({
    super.key,
    required this.hadith,
    required this.wordsMeanings,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> wordMap = {
      for (var wm in wordsMeanings) normalizeArabic(wm.word!): wm.meaning ?? "",
    };

    final words = hadith.split(" ");

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: words.map((word) {
          final cleaned = word.replaceAll(RegExp(r'[^\u0600-\u06FFa-zA-Z0-9]'), "");
          final finalWord = normalizeArabic(cleaned);
          final isSpecial = wordMap.containsKey(finalWord.trim());

          if (isSpecial) {
            return WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        backgroundColor: ColorsManager.secondaryBackground,
                        title: Text(
                          cleaned,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.primaryPurple,
                          ),
                        ),
                        content: Text(wordMap[finalWord] ?? "لا يوجد معنى"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("إغلاق"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text(
                  "$word ",
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "Amiri",
                    height: 1.8,
                    color: ColorsManager.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          return TextSpan(
            text: "$word ",
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "Amiri",
              height: 1.8,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          );
        }).toList(),
      ),
    );
  }

  String normalizeArabic(String text) {
    final diacritics = RegExp(r'[\u0617-\u061A\u064B-\u0652]');
    String result = text.replaceAll(diacritics, '');
    result = result.replaceAll(RegExp('[إأآ]'), 'ا');
    result = result.replaceAll('ـ', '');
    result = result.toLowerCase();
    return result;
  }
}

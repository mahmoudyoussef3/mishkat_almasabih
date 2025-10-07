import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/new_daily_hadith_model.dart';

class HadithAttributionAndGrade extends StatelessWidget {
  final NewDailyHadithModel data;
  const HadithAttributionAndGrade({super.key, required this.data});

  Color gradeColor(String? g) {
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

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (data?.attribution != null)
          Flexible(
            child: Text(
              "📖 ${data?.attribution!}",
              style: const TextStyle(
                fontSize: 16,
                color: ColorsManager.accentPurple,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        if (data?.grade != null)
          Chip(
            backgroundColor: gradeColor(data?.grade).withOpacity(0.1),
            label: Text(
            data?.grade??"",
              style: TextStyle(
                color: gradeColor(data?.grade),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

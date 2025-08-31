import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';

class HadithAttributionAndGrade extends StatelessWidget {
  final DailyHadithModel data;
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
        if (data.data?.attribution != null)
          Flexible(
            child: Text(
              "📖 ${data.data?.attribution!}",
              style: const TextStyle(
                fontSize: 16,
                color: ColorsManager.accentPurple,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        if (data.data?.grade != null)
          Chip(
            backgroundColor: gradeColor(data.data?.grade).withOpacity(0.1),
            label: Text(
            data.data?.grade??"",
              style: TextStyle(
                color: gradeColor(data.data?.grade),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

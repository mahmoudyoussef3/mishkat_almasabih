import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class HadithTabContent extends StatelessWidget {
  final String selectedTab;
  final DailyHadithModel? data;

  const HadithTabContent({
    super.key,
    required this.selectedTab,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case "شرح":
        return Text(
          data?.data?.explanation ?? "لا يوجد شرح",
          style: const TextStyle(fontSize: 16, height: 1.6),
          textAlign: TextAlign.justify,
        );

      case "الدروس المستفادة":
        if (data?.data?.hints != null && data!.data!.hints!.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data!.data!.hints!.map<Widget>(
              (hint) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text("• $hint", style: const TextStyle(fontSize: 16)),
              ),
            ).toList(),
          );
        }
        return const Text("لا توجد فوائد");

      case "معاني الكلمات":
        if (data?.data?.wordsMeanings != null && data!.data!.wordsMeanings!.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data!.data!.wordsMeanings!.map<Widget>(
              (wm) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: wm.word ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.darkPurple,
                        ),
                      ),
                      const TextSpan(
                        text: ": ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.darkPurple,
                        ),
                      ),
                      TextSpan(
                        text: wm.meaning ?? "",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).toList(),
          );
        }
        return const Text("لا توجد معاني");

      default:
        return const SizedBox.shrink();
    }
  }
}

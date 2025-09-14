import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/search/enhanced_public_search/data/models/enhanced_search_response_model.dart';

class ResultHadithTabContent extends StatelessWidget {
  final String selectedTab;
  final EnhancedHadithModel? data;

  const ResultHadithTabContent({
    super.key,
    required this.selectedTab,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    int count = 1;

    switch (selectedTab) {
      case "شرح":
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: data?.explanation ?? "لا يوجد شرح",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: ColorsManager.black,
                  height: 1.6,
                ),
              ),
            ],
          ),
        );

      case "الدروس المستفادة":
        if (data?.hints != null && data!.hints!.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                data!.hints!
                    .map<Widget>(
                      (hint) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${count++}- ".toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorsManager.black,
                                ),
                              ),
                              TextSpan(
                                text: hint,
                                
                                style: TextStyle(
                                  
                                                    fontWeight: FontWeight.w800,

                                  color: ColorsManager.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          );
        }
        return const Text("لا توجد فوائد");

      case "معاني الكلمات":
        if (data?.words_meanings != null &&
            data!.words_meanings!.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                data!.words_meanings!
                    .map<Widget>(
                      (wm) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: wm.word ,
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
                                text: wm.meaning ,
                                style: const TextStyle(
                                  fontSize: 15,
                                                    fontWeight: FontWeight.w800,

                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          );
        }
        return const Text("لا توجد معاني");

      default:
        return const SizedBox.shrink();
    }
  }
}

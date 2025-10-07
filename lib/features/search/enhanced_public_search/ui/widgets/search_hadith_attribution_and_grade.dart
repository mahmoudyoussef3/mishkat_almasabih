import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/helpers/functions.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/search/enhanced_public_search/data/models/enhanced_search_response_model.dart';

class searchHadithAttributionAndGrade extends StatelessWidget {
  final EnhancedHadithModel enhancedHadithModel;
  const searchHadithAttributionAndGrade({super.key, required this.enhancedHadithModel});


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (enhancedHadithModel.attribution != null)
          Flexible(
            child: Text(
              "📖 ${enhancedHadithModel.attribution!}",
              style: const TextStyle(
                fontSize: 16,
                color: ColorsManager.accentPurple,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        if (enhancedHadithModel.grade != null)
          Chip(
            backgroundColor: getGradeColor(enhancedHadithModel.grade).withOpacity(0.1),
            label: Text(
            enhancedHadithModel.grade??"",
              style: TextStyle(
                color: getGradeColor(enhancedHadithModel.grade),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

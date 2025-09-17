import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';

class FeaturedHadithCard extends StatelessWidget {
  final String hadithNumber;
  final String hadithText;
  final String narrator;
  final String book;

  const FeaturedHadithCard({
    required this.hadithNumber, required this.hadithText, required this.narrator, required this.book, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient background
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Spacing.md),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorsManager.primaryPurple,
                  ColorsManager.secondaryPurple,
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: ColorsManager.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(Spacing.sm),
                  ),
                  child: const Icon(
                    Icons.format_quote,
                    color: ColorsManager.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hadith #$hadithNumber',
                        style: TextStyles.labelLarge.copyWith(
                          color: ColorsManager.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        book,
                        style: TextStyles.labelMedium.copyWith(
                          color: ColorsManager.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: ColorsManager.white,
                    size: 20,
                  ),
                  onPressed: () {
                    // TODO: Add to bookmarks
                  },
                ),
              ],
            ),
          ),

          // Hadith content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hadithText,
                    style: TextStyles.hadithText.copyWith(
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),

                  // Footer with narrator info
                  Container(
                    padding: EdgeInsets.all(Spacing.sm),
                    decoration: BoxDecoration(
                      color: ColorsManager.lightGray,
                      borderRadius: BorderRadius.circular(Spacing.sm),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: ColorsManager.primaryPurple,
                        ),
                        SizedBox(width: Spacing.xs),
                        Expanded(
                          child: Text(
                            'Narrated by $narrator',
                            style: TextStyles.labelMedium.copyWith(
                              color: ColorsManager.primaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.share_outlined,
                            size: 16,
                            color: ColorsManager.primaryPurple,
                          ),
                          onPressed: () {
                            // TODO: Share hadith
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

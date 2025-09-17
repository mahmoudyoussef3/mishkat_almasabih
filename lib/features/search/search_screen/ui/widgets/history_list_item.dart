import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';

class HistoryListItem extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const HistoryListItem({
    required this.item, required this.onRemove, required this.onTap, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: ColorsManager.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorsManager.mediumGray),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${item.time} - ${item.date}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: ColorsManager.primaryGreen,
                ),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

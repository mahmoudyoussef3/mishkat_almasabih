import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';
import 'history_list_item.dart';

class HistoryList extends StatelessWidget {
  final List<HistoryItem> items;
  final Function(int) onRemove;
  final VoidCallback onClearAll;

  const HistoryList({
    super.key,
    required this.items,
    required this.onRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "سجل البحث",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.darkPurple,
                  ),
                ),
                TextButton.icon(
                  onPressed: onClearAll,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: ColorsManager.primaryGold,
                  ),
                  label: const Text(
                    "حذف الكل",
                    style: TextStyle(
                      color: ColorsManager.primaryGold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // List
            ListView.separated(
              separatorBuilder:
                  (context, index) => Divider(
                    color: ColorsManager.gray,
                    indent: 30.w,
                    endIndent: 30.w,
                  ),
              itemCount: items.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return HistoryListItem(
                  onTap:
                      () => context.pushNamed(
                        Routes.publicSearchSCreen,
                        arguments: items[index].title,
                      ),
                  item: items[index],
                  onRemove: () => onRemove(index),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

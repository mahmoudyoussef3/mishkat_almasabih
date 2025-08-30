import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';

class BookmarkCollectionsRow extends StatelessWidget {
  final String selectedCollection;
  final ValueChanged<String> onCollectionSelected;

  const BookmarkCollectionsRow({
    super.key,
    required this.selectedCollection,
    required this.onCollectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GetCollectionsBookmarkCubit,
      GetCollectionsBookmarkState
    >(
      builder: (context, state) {
        if (state is GetCollectionsBookmarkLoading) {
          /// 🔹 Shimmer effect while loading
          return SizedBox(
            height: 50.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 5,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder:
                  (_, __) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 80.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: ColorsManager.lightGray,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                    ),
                  ),
            ),
          );
        } else if (state is GetCollectionsBookmarkSuccess) {
          final collections = state.collectionsResponse.collections;
          final allCollections = [
            "الكل",
            ...collections!.map((e) => e.collection ?? ""),
          ];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: ColorsManager.secondaryBackground,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: ColorsManager.primaryGreen, width: 1),
              ),
              height: 56.h,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: allCollections.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final c = allCollections[index];
                  final isSelected = selectedCollection == c;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        c ?? "",
                        style: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : ColorsManager.primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: ColorsManager.primaryPurple,
                      backgroundColor: ColorsManager.lightGray.withOpacity(0.6),
                      pressElevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      onSelected: (_) => onCollectionSelected(c),
                    ),
                  );
                },
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

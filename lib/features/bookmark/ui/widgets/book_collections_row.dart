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
    return BlocBuilder<GetCollectionsBookmarkCubit, GetCollectionsBookmarkState>(
      builder: (context, state) {
        if (state is GetCollectionsBookmarkLoading) {
          return SizedBox(
            height: 46.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 5,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 80.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: ColorsManager.lightGray,
                    borderRadius: BorderRadius.circular(20.r),
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
                padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: ColorsManager.secondaryBackground,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: SizedBox(
                height: 50.h,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemCount: allCollections.length,
                  itemBuilder: (context, index) {
                    final c = allCollections[index];
                    final isSelected = selectedCollection == c;
                  
                    return Padding(
                      padding:  EdgeInsets.only(left: 16.w),
                      child: GestureDetector(
                        onTap: () => onCollectionSelected(c),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorsManager.primaryPurple
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: isSelected
                                  ? ColorsManager.primaryPurple
                                  : ColorsManager.mediumGray.withOpacity(0.4),
                              width: 1.2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: ColorsManager.primaryPurple.withOpacity(0.25),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    )
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              c,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : ColorsManager.primaryText,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
          
        }
        return const SizedBox.shrink();
      },
    );
  }
}

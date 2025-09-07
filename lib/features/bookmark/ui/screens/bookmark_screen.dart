import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/book_collections_row.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/bookmark_list.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  String selectedCollection = "الكل";

  @override
  Widget build(BuildContext context) {
    return  Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorsManager.secondaryBackground,
          body: CustomScrollView(
            slivers: [
              BuildHeaderAppBar(title: "الأحاديث المحفوظة"),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),

              SliverToBoxAdapter(
                child: BookmarkCollectionsRow(
                  selectedCollection: selectedCollection,
                  onCollectionSelected: (collection) {
                    setState(() => selectedCollection = collection);
                  },
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 4.h)),
              _buildDividerSection(),
              SliverToBoxAdapter(child: SizedBox(height: 4.h)),
              BookmarkList(selectedCollection: selectedCollection),

              SliverToBoxAdapter(child: SizedBox(height: 50.h)),
            ],
          ),
        ),

    );
  }

  Widget _buildIslamicSeparator() {
    return Container(
      height: 1.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.primaryPurple.withOpacity(0.3),
            ColorsManager.primaryGold.withOpacity(0.6),
            ColorsManager.primaryPurple.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(1.r),
      ),
    );
  }

  Widget _buildDividerSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
        child: _buildIslamicSeparator(),
      ),
    );
  }
}

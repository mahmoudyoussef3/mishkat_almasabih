import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/widgets/double_tap_to_exot.dart';
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
    return SafeArea(
      top: false,

      child: DoubleTapToExitApp(
        myScaffoldScreen: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: ColorsManager.secondaryBackground,
            body: CustomScrollView(
              slivers: [
                BuildHeaderAppBar(bottomNav: true, title: "الأحاديث المحفوظة"),
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
                SliverToBoxAdapter(child: SizedBox(height: 4.h)),
                BookmarkList(selectedCollection: selectedCollection),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

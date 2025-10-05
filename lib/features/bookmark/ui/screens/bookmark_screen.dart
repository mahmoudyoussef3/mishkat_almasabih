import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';
import 'package:mishkat_almasabih/core/widgets/double_tap_to_exot.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _query = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,

      child: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: ColorsManager.secondaryBackground,
              body: CustomScrollView(
                slivers: [
                  BuildHeaderAppBar(bottomNav: true, title: "الأحاديث المحفوظة"),
                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Card(
                        color: ColorsManager.secondaryBackground,
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorsManager.white,
                            borderRadius: BorderRadius.circular(
                              Spacing.cardRadius,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ColorsManager.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _query = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'ابحث بنص الحديث او الملاحظات...',
                              hintStyle: TextStyles.bodyMedium.copyWith(
                                color: ColorsManager.secondaryText,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: ColorsManager.primaryPurple,
                                size: 24,
                              ),
            
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: Spacing.md,
                                vertical: Spacing.md,
                              ),
                            ),
                            style: TextStyles.bodyMedium,
                            textInputAction: TextInputAction.search,
                          ),
                        ),
                      ),
                    ),
                  ),
            
                  SliverToBoxAdapter(
                    child: BookmarkCollectionsRow(
                      selectedCollection: selectedCollection,
                      onCollectionSelected: (collection) {
                        setState(() => selectedCollection = collection);
                      },
                    ),
                  ),
            
                  BookmarkList(
                    selectedCollection: selectedCollection,
                    query: _query,
                  ),
                ],
              ),
            ),
          ),
        ),
      
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_book_data_state_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_main_category_card.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/styles.dart';
import '../../../core/helpers/spacing.dart';
import 'widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: CustomScrollView(
          slivers: [
            BuildHeaderAppBar(),
            SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.screenHorizontal,
                ),
                child: SearchBarWidget(
                  controller: _searchController,
                  onSearch: (query) {},
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Spacing.screenHorizontal),
                child: Row(
                  children: [
                    Expanded(
                      child: BuildBookDataStateCard(
                        icon: Icons.book,
                        title: 'إجمالي الكتب',
                        value: '17',
                        color: ColorsManager.primaryPurple,
                      ),
                    ),
                    SizedBox(width: Spacing.md),
                    Expanded(
                      child: BuildBookDataStateCard(
                        icon: Icons.folder,
                        title: 'الأبواب',
                        value: '2,847',
                        color: ColorsManager.secondaryPurple,
                      ),
                    ),
                    SizedBox(width: Spacing.md),
                    Expanded(
                      child: BuildBookDataStateCard(
                        icon: Icons.format_quote,
                        title: 'الأحاديث',
                        value: '45,632',
                        color: ColorsManager.primaryGold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Divider(
                color: ColorsManager.primaryNavy,
                endIndent: 30.h,
                indent: 30.h,
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Spacing.screenHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الكتب الرئيسية',
                      style: TextStyles.headlineMedium.copyWith(
                        color: ColorsManager.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Spacing.md),

                    BuildMainCategoryCard(
                      title: 'كتب الأحاديث الكبيرة',
                      subtitle: '11 كتاب',
                      description: 'المجاميع الكبيرة للأحاديث الصحيحة',
                      icon: Icons.library_books,
                      bookCount: 11,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorsManager.primaryPurple,
                          ColorsManager.secondaryPurple,
                        ],
                      ),
                      onTap: () {},
                    ),

                    SizedBox(height: Spacing.md),

                    BuildMainCategoryCard(
                      title: 'كتب الأربعينات',
                      subtitle: '3 كتب',
                      description: 'مجموعات الأربعين حديثاً',
                      icon: Icons.format_list_numbered,
                      bookCount: 3,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorsManager.primaryPurple,
                          ColorsManager.secondaryPurple,
                        ],
                      ),
                      onTap: () {},
                    ),

                    SizedBox(height: Spacing.md),

                    BuildMainCategoryCard(
                      title: 'كتب الأدب والآداب',
                      subtitle: '3 كتب',
                      description: 'كتب الآداب والأخلاق الإسلامية',
                      icon: Icons.psychology,
                      bookCount: 3,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorsManager.primaryPurple,
                          ColorsManager.secondaryPurple,
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: Spacing.lg)),
          ],
        ),
      ),
    );
  }
}

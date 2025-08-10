import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theming/colors.dart';
import '../../core/theming/styles.dart';
import '../../core/helpers/spacing.dart';
import 'widgets/category_card.dart';
import 'widgets/featured_hadith_card.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/quick_actions.dart';

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
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: ColorsManager.primaryGreen,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'مشكاة المصابيح',
                  style: TextStyles.displaySmall.copyWith(
                    color: ColorsManager.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorsManager.primaryGreen,
                        ColorsManager.secondaryGreen,
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: ColorsManager.white),
                  onPressed: () {
                    // TODO: Navigate to notifications
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline, color: ColorsManager.white),
                  onPressed: () {
                    // TODO: Navigate to profile
                  },
                ),
              ],
            ),
            
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Spacing.screenHorizontal),
                child: SearchBarWidget(
                  controller: _searchController,
                  onSearch: (query) {
                    // TODO: Implement search functionality
                  },
                ),
              ),
            ),
            
            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.screenHorizontal),
                child: QuickActions(),
              ),
            ),
            
            // Featured Content Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Spacing.screenHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Hadith',
                      style: TextStyles.headlineMedium.copyWith(
                        color: ColorsManager.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Spacing.md),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: Spacing.md),
                            child: FeaturedHadithCard(
                              hadithNumber: '${index + 1}',
                              hadithText: 'Sample hadith text for featured content...',
                              narrator: 'Abu Hurairah',
                              book: 'Sahih Bukhari',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Categories Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Spacing.screenHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyles.headlineMedium.copyWith(
                        color: ColorsManager.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Spacing.md),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: Spacing.md,
                        mainAxisSpacing: Spacing.md,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final categories = [
                          {'name': 'Hadith', 'icon': Icons.book, 'color': ColorsManager.primaryGreen},
                          {'name': 'Quran', 'icon': Icons.menu_book, 'color': ColorsManager.primaryGold},
                          {'name': 'Fiqh', 'icon': Icons.gavel, 'color': ColorsManager.primaryNavy},
                          {'name': 'Aqeedah', 'icon': Icons.psychology, 'color': ColorsManager.secondaryGreen},
                          {'name': 'Seerah', 'icon': Icons.history, 'color': ColorsManager.accentOrange},
                          {'name': 'Tafsir', 'icon': Icons.auto_stories, 'color': ColorsManager.accentPurple},
                        ];
                        
                        return CategoryCard(
                          name: categories[index]['name'] as String,
                          icon: categories[index]['icon'] as IconData,
                          color: categories[index]['color'] as Color,
                          onTap: () {
                            // TODO: Navigate to category
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Recent Books Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Spacing.screenHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Books',
                          style: TextStyles.headlineMedium.copyWith(
                            color: ColorsManager.primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to all books
                          },
                          child: Text(
                            'View All',
                            style: TextStyles.linkText,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Spacing.md),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: Spacing.md),
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                color: ColorsManager.cardBackground,
                                borderRadius: BorderRadius.circular(Spacing.cardRadius),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorsManager.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.book,
                                    size: 32,
                                    color: ColorsManager.primaryGreen,
                                  ),
                                  SizedBox(height: Spacing.sm),
                                  Text(
                                    'Book ${index + 1}',
                                    style: TextStyles.labelMedium,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom spacing
            SliverToBoxAdapter(
              child: SizedBox(height: Spacing.xxl),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Quick search or add bookmark
        },
        backgroundColor: ColorsManager.primaryGold,
        child: const Icon(
          Icons.search,
          color: ColorsManager.black,
        ),
      ),
    );
  }
}

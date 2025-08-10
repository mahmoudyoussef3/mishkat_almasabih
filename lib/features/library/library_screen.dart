import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theming/colors.dart';
import '../../core/theming/styles.dart';
import '../../core/helpers/spacing.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Hadith',
    'Quran',
    'Fiqh',
    'Aqeedah',
    'Seerah',
    'Tafsir',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Library',
          style: TextStyles.headlineMedium.copyWith(
            color: ColorsManager.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorsManager.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.sort,
              color: ColorsManager.primaryGreen,
            ),
            onPressed: () {
              // TODO: Show sort options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: Spacing.screenHorizontal),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: Spacing.md),
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? ColorsManager.primaryGreen
                          : ColorsManager.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected 
                            ? ColorsManager.primaryGreen
                            : ColorsManager.mediumGray,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyles.labelMedium.copyWith(
                          color: isSelected 
                              ? ColorsManager.white
                              : ColorsManager.primaryText,
                          fontWeight: isSelected 
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: Spacing.md),

          // Library Content
          Expanded(
            child: _buildLibraryContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryContent() {
    if (_selectedCategory == 'All') {
      return _buildAllCategories();
    } else {
      return _buildCategoryBooks();
    }
  }

  Widget _buildAllCategories() {
    return Padding(
      padding: EdgeInsets.all(Spacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reading Progress',
            style: TextStyles.headlineMedium.copyWith(
              color: ColorsManager.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Spacing.md),
          _buildProgressCards(),
          SizedBox(height: Spacing.xl),
          Text(
            'Recent Books',
            style: TextStyles.headlineMedium.copyWith(
              color: ColorsManager.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Spacing.md),
          Expanded(
            child: _buildRecentBooksList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCards() {
    final progressData = [
      {'category': 'Hadith', 'progress': 0.75, 'color': ColorsManager.primaryGreen},
      {'category': 'Quran', 'progress': 0.45, 'color': ColorsManager.primaryGold},
      {'category': 'Fiqh', 'progress': 0.30, 'color': ColorsManager.primaryNavy},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: progressData.length,
        itemBuilder: (context, index) {
          final data = progressData[index];
          return Container(
            width: 150,
            margin: EdgeInsets.only(right: Spacing.md),
            padding: EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: ColorsManager.white,
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['category'] as String,
                  style: TextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Spacing.sm),
                LinearProgressIndicator(
                  value: data['progress'] as double,
                  backgroundColor: ColorsManager.lightGray,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    data['color'] as Color,
                  ),
                ),
                SizedBox(height: Spacing.xs),
                Text(
                  '${((data['progress'] as double) * 100).toInt()}%',
                  style: TextStyles.labelSmall.copyWith(
                    color: ColorsManager.secondaryText,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentBooksList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildBookItem(index);
      },
    );
  }

  Widget _buildBookItem(int index) {
    return Card(
      margin: EdgeInsets.only(bottom: Spacing.md),
      child: ListTile(
        contentPadding: EdgeInsets.all(Spacing.md),
        leading: Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            color: ColorsManager.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(Spacing.sm),
            border: Border.all(
              color: ColorsManager.primaryGreen.withOpacity(0.3),
            ),
          ),
          child: Icon(
            Icons.book,
            color: ColorsManager.primaryGreen,
            size: 30,
          ),
        ),
        title: Text(
          'Book Title ${index + 1}',
          style: TextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Author Name',
              style: TextStyles.bodyMedium.copyWith(
                color: ColorsManager.primaryGold,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: Spacing.xs),
            Text(
              'Category • ${_categories[index % _categories.length]}',
              style: TextStyles.bodySmall.copyWith(
                color: ColorsManager.secondaryText,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: ColorsManager.gray,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.bookmark_border, size: 20),
                  SizedBox(width: Spacing.sm),
                  Text('Add to Bookmarks'),
                ],
              ),
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.share_outlined, size: 20),
                  SizedBox(width: Spacing.sm),
                  Text('Share'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          // TODO: Navigate to book detail
        },
      ),
    );
  }

  Widget _buildCategoryBooks() {
    return Padding(
      padding: EdgeInsets.all(Spacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedCategory,
            style: TextStyles.headlineMedium.copyWith(
              color: ColorsManager.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Spacing.md),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: Spacing.md,
                mainAxisSpacing: Spacing.md,
                childAspectRatio: 0.8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return _buildCategoryBookCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBookCard(int index) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorsManager.primaryGreen.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Icon(
                Icons.book,
                color: ColorsManager.primaryGreen,
                size: 40,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book ${index + 1}',
                  style: TextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Spacing.xs),
                Text(
                  'Author Name',
                  style: TextStyles.bodySmall.copyWith(
                    color: ColorsManager.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

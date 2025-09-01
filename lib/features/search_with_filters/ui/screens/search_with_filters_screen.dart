import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/search_with_filters/data/models/search_with_filters_model.dart';

// ignore: must_be_immutable
class SearchWithFiltersScreen extends StatefulWidget {
  SearchWithFiltersScreen({super.key});

  @override
  State<SearchWithFiltersScreen> createState() =>
      _SearchWithFiltersScreenState();
}

class _SearchWithFiltersScreenState extends State<SearchWithFiltersScreen> {
  // Filter states
  String? _selectedBook;

  String? _selectedNarrator;

  String? _selectedAuthenticity;

  // Mock data
  final List<String> _books = [
    'صحيح البخاري',
    'صحيح مسلم',
    'سنن أبي داود',
    'سنن الترمذي',
    'سنن النسائي',
    'سنن ابن ماجة',
    'موطأ مالك',
    'مسند أحمد',
  ];

  final List<String> _authenticityGrades = ['صحيح', 'حسن', 'ضعيف'];

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryBackground,

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(Spacing.screenHorizontal),
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsManager.primaryPurple.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (query) {
                      context.pushNamed(Routes.publicSearchSCreen,arguments:query.trim());
                    },
                    decoration: InputDecoration(
                      hintText: 'ابحث في الأحاديث...',
                      hintStyle: TextStyles.bodyMedium.copyWith(
                        color: ColorsManager.secondaryText,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: ColorsManager.primaryPurple,
                        size: 24,
                      ),
                      suffixIcon:
                          searchController.text.isNotEmpty
                              ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: ColorsManager.gray,
                                  size: 20,
                                ),
                                onPressed:
                                    () => setState(() {
                                      searchController.text = '';
                                    }),
                              )
                              : null,
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

                // Filters Section
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: Spacing.screenHorizontal,
                  ),
                  padding: EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsManager.primaryPurple.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'خيارات البحث',
                        style: TextStyles.titleMedium.copyWith(
                          color: ColorsManager.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Spacing.md),

                      // Book and Chapter Selection
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterDropdown(
                              value: _selectedBook,
                              items: ['جميع الكتب', ..._books],
                              label: 'اختر الكتاب',
                              onChanged: (value) {
                                _selectedBook = value;
                              },
                            ),
                          ),
                          SizedBox(width: Spacing.md),
                        ],
                      ),

                      SizedBox(height: Spacing.md),

                      // Narrator and Authenticity
                      Row(
                        children: [
                          Expanded(
                            child: _buildFilterDropdown(
                              value: _selectedAuthenticity,
                              items: ['جميع الدرجات', ..._authenticityGrades],
                              label: 'درجة الصحة',
                              onChanged: (value) {
                                setState(() {
                                  _selectedAuthenticity = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Recent Searches Section
                Container(
                  margin: EdgeInsets.all(Spacing.screenHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'البحث الأخير',
                            style: TextStyles.titleMedium.copyWith(
                              color: ColorsManager.primaryText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'مسح الكل',
                              style: TextStyles.bodyMedium.copyWith(
                                color: ColorsManager.primaryPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Spacing.md),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.labelMedium.copyWith(
            color: ColorsManager.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Spacing.xs),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Spacing.md),
          decoration: BoxDecoration(
            color: ColorsManager.offWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorsManager.mediumGray.withOpacity(0.3),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(
                label,
                style: TextStyles.bodyMedium.copyWith(
                  color: ColorsManager.secondaryText,
                ),
              ),
              items:
                  items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyles.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: ColorsManager.primaryPurple,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

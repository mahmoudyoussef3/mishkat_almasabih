import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theming/colors.dart';
import '../../core/theming/styles.dart';
import '../../core/helpers/spacing.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Filter states
  String? _selectedBook;
  String? _selectedChapter;
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

  final List<String> _chapters = [
    'كتاب الإيمان',
    'كتاب الطهارة',
    'كتاب الصلاة',
    'كتاب الزكاة',
    'كتاب الصوم',
    'كتاب الحج',
    'كتاب النكاح',
    'كتاب الطلاق',
  ];

  final List<String> _narrators = [
    'أبو هريرة',
    'عبد الله بن عمر',
    'عائشة أم المؤمنين',
    'عبد الله بن عباس',
    'أبو سعيد الخدري',
    'أنس بن مالك',
    'جابر بن عبد الله',
    'عبد الله بن مسعود',
  ];

  final List<String> _authenticityGrades = ['صحيح', 'حسن', 'ضعيف', 'موضوع'];

  final List<String> _recentSearches = [
    'الصلاة في وقتها',
    'بر الوالدين',
    'الصدقة',
    'الصبر على البلاء',
    'طلب العلم',
    'الأمانة',
    'الوفاء بالعهد',
    'حسن الخلق',
  ];

  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isSearching = false;
        // Mock search results
        _searchResults = List.generate(
          5,
          (index) => {
            'id': index + 1,
            'text':
                'عن أبي هريرة رضي الله عنه قال: قال رسول الله صلى الله عليه وسلم: "من حسن إسلام المرء تركه ما لا يعنيه"',
            'narrator': 'أبو هريرة',
            'authenticity': 'صحيح',
            'book': 'صحيح البخاري',
            'chapter': 'كتاب الإيمان',
          },
        );
      });
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults.clear();
    });
  }

  void _clearAllRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  void _addToRecentSearches(String query) {
    if (!_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryBackground,
      appBar: AppBar(
        title: Text(
          'البحث في الأحاديث',
          style: TextStyles.headlineMedium.copyWith(
            color: ColorsManager.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorsManager.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
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
              controller: _searchController,
              onSubmitted: (query) {
                _addToRecentSearches(query);
                _performSearch();
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
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: ColorsManager.gray,
                            size: 20,
                          ),
                          onPressed: _clearSearch,
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
            margin: EdgeInsets.symmetric(horizontal: Spacing.screenHorizontal),
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
                          setState(() {
                            _selectedBook = value;
                            _selectedChapter =
                                null; // Reset chapter when book changes
                          });
                        },
                      ),
                    ),
                    SizedBox(width: Spacing.md),
                    Expanded(
                      child: _buildFilterDropdown(
                        value: _selectedChapter,
                        items: ['جميع الأبواب', ..._chapters],
                        label: 'اختر الباب',
                        onChanged: (value) {
                          setState(() {
                            _selectedChapter = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Spacing.md),

                // Narrator and Authenticity
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        value: _selectedNarrator,
                        items: ['جميع الرواة', ..._narrators],
                        label: 'اختر الراوي',
                        onChanged: (value) {
                          setState(() {
                            _selectedNarrator = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: Spacing.md),
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
          if (_recentSearches.isNotEmpty && _searchResults.isEmpty)
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
                        onPressed: _clearAllRecentSearches,
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
                  SizedBox(
                    height: 50.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _recentSearches.length,
                      itemBuilder: (context, index) {
                        return _buildRecentSearchChip(_recentSearches[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Search Results or Empty State
          Expanded(child: _buildSearchContent()),
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

  Widget _buildRecentSearchChip(String query) {
    return GestureDetector(
      onTap: () {
        _searchController.text = query;
        _addToRecentSearches(query);
        _performSearch();
      },
      child: Container(
        margin: EdgeInsets.only(right: Spacing.sm),
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        decoration: BoxDecoration(
          color: ColorsManager.primaryPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ColorsManager.primaryPurple.withOpacity(0.3),
          ),
        ),
        child: Text(
          query,
          style: TextStyles.labelMedium.copyWith(
            color: ColorsManager.primaryPurple,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchContent() {
    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: ColorsManager.primaryPurple),
            SizedBox(height: Spacing.md),
            Text(
              'جاري البحث...',
              style: TextStyles.bodyMedium.copyWith(
                color: ColorsManager.secondaryText,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return _buildEmptyState();
    }

    if (_searchResults.isNotEmpty) {
      return _buildSearchResults();
    }

    return _buildInitialState();
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80.sp, color: ColorsManager.mediumGray),
          SizedBox(height: Spacing.md),
          Text(
            'ابحث في الأحاديث الشريفة',
            style: TextStyles.headlineSmall.copyWith(
              color: ColorsManager.secondaryText,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Spacing.sm),
          Text(
            'استخدم شريط البحث أعلاه للعثور على الأحاديث',
            style: TextStyles.bodyMedium.copyWith(
              color: ColorsManager.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: ColorsManager.mediumGray),
          SizedBox(height: Spacing.md),
          Text(
            'لم يتم العثور على أحاديث',
            style: TextStyles.headlineSmall.copyWith(
              color: ColorsManager.secondaryText,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Spacing.sm),
          Text(
            'جرب تغيير كلمات البحث أو إزالة بعض الفلاتر',
            style: TextStyles.bodyMedium.copyWith(
              color: ColorsManager.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: EdgeInsets.all(Spacing.screenHorizontal),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return _buildSearchResultItem(result);
      },
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> result) {
    return Container(
      margin: EdgeInsets.only(bottom: Spacing.md),
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
      child: Padding(
        padding: EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with authenticity grade
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _getAuthenticityColor(
                      result['authenticity'],
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getAuthenticityColor(
                        result['authenticity'],
                      ).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    result['authenticity'],
                    style: TextStyles.labelSmall.copyWith(
                      color: _getAuthenticityColor(result['authenticity']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.bookmark_border,
                    color: ColorsManager.primaryPurple,
                    size: 20,
                  ),
                  onPressed: () {
                    // TODO: Add to bookmarks
                  },
                ),
              ],
            ),

            SizedBox(height: Spacing.sm),

            // Hadith text
            Text(
              result['text'],
              style: TextStyles.bodyMedium.copyWith(
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: Spacing.md),

            // Footer info
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: ColorsManager.secondaryText,
                ),
                SizedBox(width: Spacing.xs),
                Text(
                  result['narrator'],
                  style: TextStyles.labelMedium.copyWith(
                    color: ColorsManager.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: Spacing.md),
                Icon(
                  Icons.book_outlined,
                  size: 16,
                  color: ColorsManager.secondaryText,
                ),
                SizedBox(width: Spacing.xs),
                Text(
                  '${result['book']} - ${result['chapter']}',
                  style: TextStyles.labelMedium.copyWith(
                    color: ColorsManager.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAuthenticityColor(String authenticity) {
    switch (authenticity) {
      case 'صحيح':
        return ColorsManager.hadithAuthentic;
      case 'حسن':
        return ColorsManager.hadithGood;
      case 'ضعيف':
        return ColorsManager.hadithWeak;
      default:
        return ColorsManager.gray;
    }
  }
}

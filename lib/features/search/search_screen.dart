import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/features/home/widgets/search_bar_widget.dart';

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
  String _selectedCategory = 'All';
  String _selectedBook = 'All Books';

  final List<String> _categories = [
    'All',
    'Hadith',
    'Quran',
    'Fiqh',
    'Aqeedah',
    'Seerah',
    'Tafsir',
  ];

  final List<String> _books = [
    'All Books',
    'Sahih Bukhari',
    'Sahih Muslim',
    'Abu Dawud',
    'Tirmidhi',
    'Nasai',
    'Ibn Majah',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyles.headlineMedium.copyWith(
            color: ColorsManager.primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorsManager.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(Spacing.screenHorizontal),
            child: SearchBarWidget(
              controller: _searchController,
              onSearch: (query) {
                // TODO: Implement search
              },
              hintText: 'Search in Islamic texts...',
            ),
          ),

          // Filters
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.screenHorizontal),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterDropdown(
                    value: _selectedCategory,
                    items: _categories,
                    label: 'Category',
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
                SizedBox(width: Spacing.md),
                Expanded(
                  child: _buildFilterDropdown(
                    value: _selectedBook,
                    items: _books,
                    label: 'Book',
                    onChanged: (value) {
                      setState(() {
                        _selectedBook = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: Spacing.md),

          // Search Results or Suggestions
          Expanded(child: _buildSearchContent()),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
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
            color: ColorsManager.white,
            borderRadius: BorderRadius.circular(Spacing.inputRadius),
            border: Border.all(color: ColorsManager.mediumGray),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
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
                color: ColorsManager.primaryGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchContent() {
    if (_searchController.text.isEmpty) {
      return _buildSearchSuggestions();
    } else {
      return _buildSearchResults();
    }
  }

  Widget _buildSearchSuggestions() {
    return Padding(
      padding: EdgeInsets.all(Spacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Searches',
            style: TextStyles.headlineMedium.copyWith(
              color: ColorsManager.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Spacing.md),
          Wrap(
            spacing: Spacing.sm,
            runSpacing: Spacing.sm,
            children:
                [
                  'Prayer',
                  'Charity',
                  'Patience',
                  'Knowledge',
                  'Family',
                  'Business',
                  'Health',
                  'Travel',
                ].map((tag) => _buildSearchTag(tag)).toList(),
          ),
          SizedBox(height: Spacing.xl),
          Text(
            'Recent Searches',
            style: TextStyles.headlineMedium.copyWith(
              color: ColorsManager.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Spacing.md),
          _buildRecentSearchItem('Surah Al-Fatiha'),
          _buildRecentSearchItem('Hadith about kindness'),
          _buildRecentSearchItem('Islamic finance rules'),
        ],
      ),
    );
  }

  Widget _buildSearchTag(String tag) {
    return GestureDetector(
      onTap: () {
        _searchController.text = tag;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        decoration: BoxDecoration(
          color: ColorsManager.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ColorsManager.primaryGreen.withOpacity(0.3),
          ),
        ),
        child: Text(
          tag,
          style: TextStyles.labelMedium.copyWith(
            color: ColorsManager.primaryGreen,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearchItem(String query) {
    return ListTile(
      leading: Icon(Icons.history, color: ColorsManager.gray, size: 20),
      title: Text(query, style: TextStyles.bodyMedium),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: ColorsManager.gray,
        size: 16,
      ),
      onTap: () {
        _searchController.text = query;
        setState(() {});
      },
    );
  }

  Widget _buildSearchResults() {
    return Padding(
      padding: EdgeInsets.all(Spacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Results',
            style: TextStyles.headlineMedium.copyWith(
              color: ColorsManager.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Spacing.md),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return _buildSearchResultItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(int index) {
    return Card(
      margin: EdgeInsets.only(bottom: Spacing.md),
      child: ListTile(
        contentPadding: EdgeInsets.all(Spacing.md),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: ColorsManager.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(Spacing.sm),
          ),
          child: Icon(
            Icons.format_quote,
            color: ColorsManager.primaryGreen,
            size: 24,
          ),
        ),
        title: Text(
          'Search Result ${index + 1}',
          style: TextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'This is a sample search result text that shows what the user searched for...',
          style: TextStyles.bodyMedium.copyWith(
            color: ColorsManager.secondaryText,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(Icons.bookmark_border, color: ColorsManager.primaryGreen),
          onPressed: () {
            // TODO: Add to bookmarks
          },
        ),
        onTap: () {
          // TODO: Navigate to result detail
        },
      ),
    );
  }
}

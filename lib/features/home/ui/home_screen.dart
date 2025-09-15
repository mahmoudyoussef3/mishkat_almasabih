import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/widgets/double_tap_to_exot.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/hadith_daily/logic/cubit/daily_hadith_cubit.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_library_statistics_cubit.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_all_books_with_categories_cubit.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_book_data_state_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_main_category_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/daily_hadith_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/search_bar_widget.dart';
import 'package:mishkat_almasabih/features/library/ui/screens/library_screen.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/repos/shared_pref_history_item_repo.dart';
import 'package:mishkat_almasabih/features/search/search_screen/logic/cubit/search_history_cubit.dart';
import 'package:mishkat_almasabih/features/search/search_screen/ui/widgets/history_shimmer.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/styles.dart';
import '../../../core/helpers/spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
// في الـ _HomeScreenState class، حدث الـ methods دي:

/// Initialize all required data on screen load
Future<void> _initializeScreen() async {
  await Future.wait([
    _loadLibraryStatistics(),
    _loadBooksWithCategories(),
  ]);
}

/// Load library statistics and daily hadith
Future<void> _loadLibraryStatistics() async {
  await Future.wait([
    context.read<GetLibraryStatisticsCubit>().emitGetStatisticsCubit(), // بدون force refresh
    context.read<DailyHadithCubit>().loadOrFetchHadith(),
  ]);
}

/// Load books with categories data
Future<void> _loadBooksWithCategories() async {
  await context.read<GetAllBooksWithCategoriesCubit>().emitGetAllBooksWithCategories(); // بدون force refresh
}

/// Handle refresh functionality (with force refresh)
Future<void> _onRefresh() async {
  debugPrint('🔄 Manual refresh triggered');
  
  await Future.wait([
    context.read<DailyHadithCubit>().fetchAndRefreshHadith(),
    context.read<GetLibraryStatisticsCubit>().emitGetStatisticsCubit(forceRefresh: true), // مع force refresh
    context.read<GetAllBooksWithCategoriesCubit>().emitGetAllBooksWithCategories(forceRefresh: true), // مع force refresh
  ]);
  
  debugPrint('✅ Manual refresh completed');
}
  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Initialize all required data on screen load


  /// Handle search functionality
  void _onSearch(String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isNotEmpty) {
      final now = DateTime.now();
      final historyItem = HistoryItem(
        title: trimmedQuery,
        date: "${now.year}-${now.month}-${now.day}",
        time: "${now.hour}:${now.minute.toString().padLeft(2, '0')}",
      );

      context.read<SearchHistoryCubit>().addItem(
        historyItem,
        searchCategory: HistoryPrefs.enhancedPublicSearch,
      );

      context.pushNamed(
        Routes.publicSearchSCreen,
        arguments: trimmedQuery,
      );
    }
  }

  /// Handle search bar tap
  void _onSearchBarTap() {
    context.read<SearchHistoryCubit>().emitHistorySearch(
      searchCategory: HistoryPrefs.enhancedPublicSearch,
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DoubleTapToExitApp(
        myScaffoldScreen: Directionality(
          textDirection: TextDirection.rtl,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: Scaffold(
              backgroundColor: ColorsManager.secondaryBackground,
              body: _buildBody(),
            ),
          ),
        ),
      ),
    );
  }

  /// Main body with multi-bloc handling
  Widget _buildBody() {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetAllBooksWithCategoriesCubit, GetAllBooksWithCategoriesState>(
          listener: (context, state) {
            if (state is GetAllBooksWithCategoriesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('خطأ في تحميل الكتب: ${state.errorMessage}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<GetLibraryStatisticsCubit, GetLibraryStatisticsState>(
        builder: (context, statisticsState) {
          return BlocBuilder<GetAllBooksWithCategoriesCubit, GetAllBooksWithCategoriesState>(
            builder: (context, booksState) {
              return _buildStateBasedContent(statisticsState, booksState);
            },
          );
        },
      ),
    );
  }

  /// Build content based on different state combinations
  Widget _buildStateBasedContent(
    GetLibraryStatisticsState statisticsState,
    GetAllBooksWithCategoriesState booksState,
  ) {
    // Show loading if either is loading
    if (statisticsState is GetLivraryStatisticsLoading || 
        booksState is GetAllBooksWithCategoriesLoading) {
      return _buildLoadingState();
    }

    // Show content if statistics are loaded (books are optional)
    if (statisticsState is GetLivraryStatisticsSuccess) {
      return _buildSuccessState(statisticsState, booksState);
    }

    // Show error if statistics failed
    if (statisticsState is GetLivraryStatisticsError) {
      return _buildErrorState(statisticsState.errorMessage);
    }

    return _buildEmptyState();
  }

  /// Loading state widget
  Widget _buildLoadingState() {
    return loadingProgressIndicator();
  }

  /// Error state widget
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Colors.red,
          ),
          SizedBox(height: 16.h),
          Text(
            'خطأ في التحميل',
            style: TextStyles.headlineMedium.copyWith(
              color: ColorsManager.primaryText,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: TextStyles.bodyMedium.copyWith(
              color: ColorsManager.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _initializeScreen,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  /// Empty state widget
  Widget _buildEmptyState() {
    return const Center(
      child: Text('لا توجد بيانات متاحة'),
    );
  }

  /// Success state with all content
  Widget _buildSuccessState(
    GetLivraryStatisticsSuccess statisticsState,
    GetAllBooksWithCategoriesState booksState,
  ) {
    return CustomScrollView(
      slivers: [
        _buildHeaderSection(),
        SliverToBoxAdapter(child: SizedBox(height: 12.h)),
        _buildSearchSection(),
        _buildDailyHadithSection(),
        _buildDividerSection(),
        _buildStatisticsSection(statisticsState),
        _buildDividerSection(),
        _buildCategoriesSection(statisticsState),
        // Add books section if books data is available
        if (booksState is GetAllBooksWithCategoriesSuccess) ...[
          _buildDividerSection(),
          _buildBooksSection(booksState),
        ],
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
      ],
    );
  }

  /// Header section
  Widget _buildHeaderSection() {
    return  BuildHeaderAppBar(
      home: true,
      title: 'مشكاة المصابيح',
      description: 'مكتبة مشكاة الإسلامية',
    );
  }

  /// Search section with history
  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Card(
          color: ColorsManager.secondaryBackground,
          elevation: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SearchBarWidget(
                onTap: _onSearchBarTap,
                controller: _controller,
                onSearch: _onSearch,
              ),
              _buildSearchHistory(),
            ],
          ),
        ),
      ),
    );
  }

  /// Search history widget
  Widget _buildSearchHistory() {
    return BlocBuilder<SearchHistoryCubit, SearchHistoryState>(
      builder: (context, state) {
        if (state is SearchHistoryLoading) {
          return const HistoryShimmer();
        }
        
        if (state is SearchHistoryError) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              "خطأ أثناء تحميل السجل",
              style: TextStyles.bodyMedium.copyWith(
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        
        if (state is SearchHistorySuccess && state.hisoryItems.isNotEmpty) {
          return _buildSearchHistoryList(state.hisoryItems);
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  /// Search history list
  Widget _buildSearchHistoryList(List<HistoryItem> items) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => Divider(
        endIndent: 30.w,
        indent: 30.w,
        height: 1.h,
        color: Colors.grey[300],
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          tileColor: Colors.white,
          title: Text(
            item.title,
            style: TextStyles.bodyMedium.copyWith(
              color: ColorsManager.primaryText,
            ),
          ),
          subtitle: Text(
            item.date,
            style: TextStyles.bodySmall.copyWith(
              color: ColorsManager.secondaryText,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              size: 22.r,
              color: ColorsManager.primaryGreen,
            ),
            onPressed: () => context.read<SearchHistoryCubit>().removeItem(
              index,
              searchCategory: HistoryPrefs.enhancedPublicSearch,
            ),
          ),
          onTap: () => context.pushNamed(
            Routes.publicSearchSCreen,
            arguments: item.title,
          ),
        );
      },
    );
  }

  /// Daily hadith section
  Widget _buildDailyHadithSection() {
    return const SliverToBoxAdapter(child: HadithOfTheDayCard());
  }

  /// Statistics section
  Widget _buildStatisticsSection(GetLivraryStatisticsSuccess state) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            _buildStatisticsHeader(),
            SizedBox(height: 16.h),
            _buildStatisticsCards(state),
          ],
        ),
      ),
    );
  }

  /// Categories section
  Widget _buildCategoriesSection(GetLivraryStatisticsSuccess state) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoriesHeader(),
            SizedBox(height: 24.h),
            _buildCategoryCards(state),
          ],
        ),
      ),
    );
  }

  /// Books section (new)
  Widget _buildBooksSection(GetAllBooksWithCategoriesSuccess state) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBooksHeader(),
            SizedBox(height: 16.h),
            _buildBooksGrid(state),
          ],
        ),
      ),
    );
  }

  /// Books header
  Widget _buildBooksHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primaryPurple.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: ColorsManager.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.menu_book,
              color: ColorsManager.primaryGreen,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'جميع الكتب',
                  style: TextStyles.headlineMedium.copyWith(
                    color: ColorsManager.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'مجموعة شاملة من الكتب الإسلامية',
                  style: TextStyles.bodyMedium.copyWith(
                    color: ColorsManager.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Books grid
  Widget _buildBooksGrid(GetAllBooksWithCategoriesSuccess state) {
    final books = state.booksResponse.allBooks;
    
    if (books.isEmpty) {
      return Container(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Text(
            'لا توجد كتب متاحة حالياً',
            style: TextStyles.bodyMedium.copyWith(
              color: ColorsManager.secondaryText,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: books.length > 6 ? 6 : books.length, // Show max 6 books
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () {
              // Navigate to book details
              // context.pushNamed(Routes.bookDetails, arguments: book);
            },
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.book,
                        size: 32.sp,
                        color: ColorsManager.primaryGreen,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    book.bookName,
                    style: TextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (book.aboutWriter != null && book.aboutWriter!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      book.bookNameUr!,
                      style: TextStyles.bodySmall.copyWith(
                        color: ColorsManager.secondaryText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Divider section
  Widget _buildDividerSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
        child: _buildIslamicSeparator(),
      ),
    );
  }

  /// Statistics header
  Widget _buildStatisticsHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primaryPurple.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: ColorsManager.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.analytics,
              color: ColorsManager.primaryPurple,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إحصائيات المكتبة',
                  style: TextStyles.headlineMedium.copyWith(
                    color: ColorsManager.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'نظرة عامة على محتويات المكتبة الإسلامية',
                  style: TextStyles.bodyMedium.copyWith(
                    color: ColorsManager.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Statistics cards
  Widget _buildStatisticsCards(GetLivraryStatisticsSuccess state) {
    return Row(
      children: [
        Expanded(
          child: BuildBookDataStateCard(
            icon: Icons.book,
            title: 'إجمالي الكتب',
            value: state.statisticsResponse.statistics.totalBooks.toString(),
            color: const Color.fromARGB(255, 51, 13, 128),
          ),
        ),
        SizedBox(width: Spacing.md),
        Expanded(
          child: BuildBookDataStateCard(
            icon: Icons.folder,
            title: 'الأبواب',
            value: state.statisticsResponse.statistics.totalChapters.toString(),
            color: ColorsManager.hadithAuthentic,
          ),
        ),
        SizedBox(width: Spacing.md),
        Expanded(
          child: BuildBookDataStateCard(
            icon: Icons.auto_stories,
            title: 'الأحاديث',
            value: state.statisticsResponse.statistics.totalHadiths.toString(),
            color: ColorsManager.primaryGold,
          ),
        ),
      ],
    );
  }

  /// Categories header
  Widget _buildCategoriesHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primaryPurple.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: ColorsManager.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.library_books,
              color: ColorsManager.primaryGold,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الكتب الرئيسية',
                  style: TextStyles.headlineMedium.copyWith(
                    color: ColorsManager.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'مصادر الأحاديث النبوية الشريفة',
                  style: TextStyles.bodyMedium.copyWith(
                    color: ColorsManager.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Category cards
  Widget _buildCategoryCards(GetLivraryStatisticsSuccess state) {
    return Column(
      children: [
        _buildCategoryCard(
          state: state,
          categoryKey: 'kutub_tisaa',
          subtitle: '11 كتاب',
          description: 'المجاميع الكبيرة للأحاديث الصحيحة',
          icon: Icons.library_books,
          gradient: _buildKutubTisaaGradient(),
          screenName: "كتب الأحاديث الكبيرة",
          screenId: 'kutub_tisaa',
        ),
        SizedBox(height: 20.h),
        _buildCategoryCard(
          state: state,
          categoryKey: 'arbaain',
          subtitle: '3 كتب',
          description: 'مجموعات الأربعين حديثاً',
          icon: Icons.format_list_numbered,
          gradient: _buildArbaainGradient(),
          screenName: 'كتب الأربعينات',
          screenId: 'arbaain',
        ),
        SizedBox(height: 20.h),
        _buildCategoryCard(
          state: state,
          categoryKey: 'adab',
          subtitle: '3 كتب',
          description: 'كتب الآداب والأخلاق الإسلامية',
          icon: Icons.psychology,
          gradient: _buildAdabGradient(),
          screenName: 'كتب الأدب و الآداب',
          screenId: 'adab',
        ),
      ],
    );
  }

  /// Individual category card
  Widget _buildCategoryCard({
    required GetLivraryStatisticsSuccess state,
    required String categoryKey,
    required String subtitle,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required String screenName,
    required String screenId,
  }) {
    final category = state.statisticsResponse.statistics.booksByCategory[categoryKey]!;

    return BuildMainCategoryCard(
      title: category.name,
      subtitle: subtitle,
      description: description,
      icon: icon,
      bookCount: category.count,
      gradient: gradient,
      onTap: () => _navigateToLibrary(screenName, screenId),
    );
  }

  /// Gradient builders
  LinearGradient _buildKutubTisaaGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorsManager.primaryGreen, ColorsManager.darkPurple],
    );
  }

  LinearGradient _buildArbaainGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorsManager.primaryGreen, ColorsManager.darkPurple],
    );
  }

  LinearGradient _buildAdabGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorsManager.primaryGreen, ColorsManager.darkPurple],
    );
  }

  /// Islamic separator
  Widget _buildIslamicSeparator() {
    return Container(
      height: 2.h,
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

  /// Navigation to library
  void _navigateToLibrary(String screenName, String screenId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LibraryScreen(name: screenName, id: screenId),
      ),
    );
  }
}
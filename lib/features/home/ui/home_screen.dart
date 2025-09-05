import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/hadith_daily/logic/cubit/daily_hadith_cubit.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_library_statistics_cubit.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_book_data_state_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_main_category_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/daily_hadith_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/search_bar_widget.dart';
import 'package:mishkat_almasabih/features/library/ui/screens/library_screen.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/repos/shared_pref_history_item_repo.dart';
import 'package:mishkat_almasabih/features/search/search_screen/logic/cubit/search_history_cubit.dart';
import 'package:mishkat_almasabih/features/search/search_screen/ui/widgets/empty_history.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initializeScreen() async {
    await _loadLibraryStatistics();
  }

  Future<void> _loadLibraryStatistics() async {
    await context.read<GetLibraryStatisticsCubit>().emitGetStatisticsCubit();
    await context.read<DailyHadithCubit>().loadOrFetchHadith();
  }

  final List<HistoryItem> _items = [];

  Future<void> addItemToHistory(HistoryItem historyItem) async {
    final existingIndex = _items.indexWhere(
      (item) => item.title == historyItem.title,
    );
    if (existingIndex != -1) {
      _items[existingIndex] = historyItem;
    } else {
      _items.add(historyItem);
    }
    await HistoryPrefs.saveHistory(_items, HistoryPrefs.enhancedPublicSearch);
    context.read<SearchHistoryCubit>().emitHistorySearch(
      searchCategory: HistoryPrefs.enhancedPublicSearch,
    );
  }

  Future<void> removeItem(int index) async {
    _items.removeAt(index);
    await HistoryPrefs.saveHistory(_items, HistoryPrefs.enhancedPublicSearch);
    context.read<SearchHistoryCubit>().emitHistorySearch(
      searchCategory: HistoryPrefs.enhancedPublicSearch,
    );
  }

  Future<void> clearAll() async {
    await HistoryPrefs.clearHistory(HistoryPrefs.enhancedPublicSearch);
    context.read<SearchHistoryCubit>().emitHistorySearch(
      searchCategory: HistoryPrefs.enhancedPublicSearch,
    );
  }

  String formatDateTime(DateTime dateTime) {
    final date =
        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    final time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return "$time - $date";
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator(
        onRefresh:
            () => context.read<DailyHadithCubit>().fetchAndRefreshHadith(),
        child: Scaffold(
          backgroundColor: ColorsManager.secondaryBackground,
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<GetLibraryStatisticsCubit, GetLibraryStatisticsState>(
      builder: (context, state) {
        if (state is GetLivraryStatisticsLoading) {
          return _buildLoadingState();
        } else if (state is GetLivraryStatisticsSuccess) {
          return _buildSuccessState(state);
        }
        return _buildEmptyState();
      },
    );
  }

  Widget _buildLoadingState() {
    return loadingProgressIndicator();
  }

  /// Builds the success state with all content
  Widget _buildSuccessState(GetLivraryStatisticsSuccess state) {
    return CustomScrollView(
      slivers: [
        _buildHeaderSection(),
        SliverToBoxAdapter(child: SizedBox(height: 12.h)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Card(
              color: ColorsManager.secondaryBackground,
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SearchBarWidget(
                    onTap: () {
                      context.read<SearchHistoryCubit>().emitHistorySearch(
                        searchCategory: HistoryPrefs.enhancedPublicSearch,
                      );
                    },
                    controller: _controller,
                    onSearch: (query) {
                      final trimmedQuery = query.trim();
                      if (trimmedQuery.isNotEmpty) {
                        final now = DateTime.now();
                        final historyItem = HistoryItem(
                          title: trimmedQuery,
                          date: "${now.year}-${now.month}-${now.day}",
                          time:
                              "${now.hour}:${now.minute.toString().padLeft(2, '0')}",
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
                    },
                  ),

                  BlocBuilder<SearchHistoryCubit, SearchHistoryState>(
                    builder: (context, state) {
                      if (state is SearchHistoryLoading) {
                        return const HistoryShimmer();
                      } else if (state is SearchHistoryError) {
                        return const Center(
                          child: Text("خطأ أثناء تحميل السجل"),
                        );
                      } else if (state is SearchHistorySuccess) {
                        if (state.hisoryItems.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.hisoryItems.length,
                          separatorBuilder:
                              (context, index) => Divider(
                                endIndent: 30.w,
                                indent: 30.w,
                                height: 1.h,
                                color: Colors.grey[300],
                              ),
                          itemBuilder: (context, index) {
                            final item = state.hisoryItems[index];
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
                                onPressed:
                                    () => context
                                        .read<SearchHistoryCubit>()
                                        .removeItem(
                                          index,
                                          searchCategory:
                                              HistoryPrefs.enhancedPublicSearch,
                                        ),
                              ),
                              onTap:
                                  () => context.pushNamed(
                                    Routes.publicSearchSCreen,
                                    arguments: item.title,
                                  ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildDailyHadithSection(),
        _buildDividerSection(),
        _buildStatisticsSection(state),
        _buildDividerSection(),
        _buildCategoriesSection(state),
        _buildBottomSpacing(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox.shrink();
  }

  Widget _buildHeaderSection() {
    return const BuildHeaderAppBar(
      home: true,
      title: 'مشكاة المصابيح',
      description: 'مكتبة مشكاة الإسلامية',
    );
  }

  Widget _buildDailyHadithSection() {
    return const SliverToBoxAdapter(child: HadithOfTheDayCard());
  }

  /// Builds the statistics section with enhanced header
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

  /// Builds the divider section with Islamic design
  Widget _buildDividerSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
        child: _buildIslamicSeparator(),
      ),
    );
  }

  /// Builds the categories section with enhanced headers
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

  /// Builds the bottom spacing for proper scrolling
  Widget _buildBottomSpacing() {
    return SliverToBoxAdapter(child: SizedBox(height: 80.h));
  }

  // ==================== COMPONENT BUILDERS ====================

  /// Builds the statistics header with icon and description
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
          _buildStatisticsHeaderIcon(),
          SizedBox(width: 16.w),
          _buildStatisticsHeaderText(),
        ],
      ),
    );
  }

  /// Builds the statistics header icon
  Widget _buildStatisticsHeaderIcon() {
    return Container(
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
    );
  }

  /// Builds the statistics header text
  Widget _buildStatisticsHeaderText() {
    return Expanded(
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
    );
  }

  /// Builds the statistics cards row
  Widget _buildStatisticsCards(GetLivraryStatisticsSuccess state) {
    return Row(
      children: [
        _buildStatisticsCard(
          icon: Icons.book,
          title: 'إجمالي الكتب',
          value: state.statisticsResponse.statistics.totalBooks.toString(),
          color: const Color.fromARGB(255, 51, 13, 128),
        ),
        SizedBox(width: Spacing.md),
        _buildStatisticsCard(
          icon: Icons.folder,
          title: 'الأبواب',
          value: state.statisticsResponse.statistics.totalChapters.toString(),
          color: ColorsManager.hadithAuthentic,
        ),
        SizedBox(width: Spacing.md),
        _buildStatisticsCard(
          icon: Icons.auto_stories,
          title: 'الأحاديث',
          value: state.statisticsResponse.statistics.totalHadiths.toString(),
          color: ColorsManager.primaryGold,
        ),
      ],
    );
  }

  /// Builds an individual statistics card
  Widget _buildStatisticsCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: BuildBookDataStateCard(
        icon: icon,
        title: title,
        value: value,
        color: color,
      ),
    );
  }

  /// Builds the categories header with icon and description
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
          _buildCategoriesHeaderIcon(),
          SizedBox(width: 16.w),
          _buildCategoriesHeaderText(),
        ],
      ),
    );
  }

  /// Builds the categories header icon
  Widget _buildCategoriesHeaderIcon() {
    return Container(
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
    );
  }

  /// Builds the categories header text
  Widget _buildCategoriesHeaderText() {
    return Expanded(
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
    );
  }

  /// Builds the category cards
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

  /// Builds an individual category card
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
    final category =
        state.statisticsResponse.statistics.booksByCategory[categoryKey]!;

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

  // ==================== GRADIENT BUILDERS ====================

  /// Builds gradient for Kutub Tisaa category
  LinearGradient _buildKutubTisaaGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorsManager.primaryGreen, ColorsManager.darkPurple],
    );
  }

  /// Builds gradient for Arbaain category
  LinearGradient _buildArbaainGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorsManager.primaryGreen, ColorsManager.darkPurple],
    );
  }

  /// Builds gradient for Adab category
  LinearGradient _buildAdabGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorsManager.primaryGreen, ColorsManager.darkPurple],
    );
  }

  // ==================== UTILITY BUILDERS ====================

  /// Builds Islamic-themed separator with gradient and star decoration
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

  // ==================== NAVIGATION METHODS ====================

  /// Navigates to the library screen with specified parameters
  void _navigateToLibrary(String screenName, String screenId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LibraryScreen(name: screenName, id: screenId),
      ),
    );
  }
}

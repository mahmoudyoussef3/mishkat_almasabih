import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/hadith_daily/logic/cubit/daily_hadith_cubit.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_library_statistics_cubit.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_book_data_state_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_main_category_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/daily_hadith_card.dart';
import 'package:mishkat_almasabih/features/library/ui/screens/library_screen.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/styles.dart';
import '../../../core/helpers/spacing.dart';

/// HomeScreen is the main dashboard of the Mishkat Al-Masabih app.
///
/// This screen displays:
/// - Daily hadith card
/// - Library statistics
/// - Main book categories
/// - Navigation to other sections
///
/// The screen follows a clean architecture pattern with:
/// - UI layer (this file)
/// - Business logic (BLoC cubit)
/// - Data layer (repository)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ==================== LIFECYCLE METHODS ====================

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  // ==================== INITIALIZATION ====================

  /// Initializes the screen by loading library statistics
  Future<void> _initializeScreen() async {
    await _loadLibraryStatistics();
  }

  /// Loads library statistics from the backend
  Future<void> _loadLibraryStatistics() async {
    await context.read<GetLibraryStatisticsCubit>().emitGetStatisticsCubit();
        await context.read<DailyHadithCubit>().emitHadithDaily();


  }

  /// Disposes of resources to prevent memory leaks
  void _disposeResources() {
    // Add any cleanup logic here if needed
  }

  // ==================== BUILD METHOD ====================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: _buildBody(),
      ),
    );
  }

  /// Builds the main body of the home screen
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

  // ==================== STATE BUILDERS ====================

  /// Builds the loading state with progress indicator
  Widget _buildLoadingState() {
    return loadingProgressIndicator();
  }

  /// Builds the success state with all content
  Widget _buildSuccessState(GetLivraryStatisticsSuccess state) {
    return CustomScrollView(
      slivers: [
        _buildHeaderSection(),
        _buildDailyHadithSection(),
        _buildStatisticsSection(state),
        _buildDividerSection(),
        _buildCategoriesSection(state),
        _buildBottomSpacing(),
      ],
    );
  }

  /// Builds the empty state when no data is available
  Widget _buildEmptyState() {
    return const SizedBox.shrink();
  }

  // ==================== SECTION BUILDERS ====================

  /// Builds the header section with app bar
  Widget _buildHeaderSection() {
    return const BuildHeaderAppBar(
      home: true,
      title: 'مشكاة المصابيح',
      description: 'مكتبة مشكاة الإسلامية',
    );
  }

  /// Builds the daily hadith section
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
            SizedBox(height: 24.h),
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
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
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
    return SliverToBoxAdapter(child: SizedBox(height: 40.h));
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
          color: ColorsManager.primaryPurple,
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
          icon: Icons.format_quote,
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
      padding: EdgeInsets.all(12.w),
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
      colors: [ColorsManager.primaryPurple, ColorsManager.secondaryPurple],
    );
  }

  /// Builds gradient for Arbaain category
  LinearGradient _buildArbaainGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorsManager.primaryGold, ColorsManager.hadithAuthentic],
    );
  }

  /// Builds gradient for Adab category
  LinearGradient _buildAdabGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ColorsManager.hadithGood, ColorsManager.accentPurple],
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

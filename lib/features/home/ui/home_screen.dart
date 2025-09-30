import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/widgets/double_tap_to_exot.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_library_statistics_cubit.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_book_data_state_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_main_category_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/daily_hadith_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/home_screen_shimmer.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/search_bar_widget.dart';
import 'package:mishkat_almasabih/features/library/ui/screens/library_screen.dart';
import 'package:mishkat_almasabih/features/random_ahadith/ui/widgets/random_ahadith_bloc_builder.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/repos/shared_pref_history_item_repo.dart';
import 'package:mishkat_almasabih/features/search/search_screen/logic/cubit/search_history_cubit.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/styles.dart';
import '../../../core/helpers/spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  bool showSearch = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _searchKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeScreen() async {
    await _loadLibraryStatistics();
  }

  Future<void> _loadLibraryStatistics() async {
    await context.read<GetLibraryStatisticsCubit>().emitGetStatisticsCubit();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showSearchHistory() {
    if (_overlayEntry != null) return;

    final renderBox =
        _searchKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final searchHistoryCubit = context.read<SearchHistoryCubit>();

    _overlayEntry = OverlayEntry(
      builder:
          (overlayContext) => BlocProvider.value(
            value: searchHistoryCubit,
            child: Positioned(
              left: position.dx,
              top: position.dy + size.height + 8,
              width: size.width,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.white,
                child: Container(
                  constraints: BoxConstraints(maxHeight: 300.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: BlocBuilder<SearchHistoryCubit, SearchHistoryState>(
                      builder: (context, state) {
                        if (state is SearchHistoryLoading) {
                          return Container(
                            height: 100.h,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        } else if (state is SearchHistoryError) {
                          return Container(
                            height: 60.h,
                            child: Center(
                              child: Text(
                                "خطأ أثناء تحميل السجل",
                                style: TextStyles.bodySmall.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                        } else if (state is SearchHistorySuccess) {
                          if (state.hisoryItems.isEmpty) {
                            return Container(
                              height: 80.h,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.history,
                                      size: 24.r,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      "لا يوجد عمليات بحث سابقة",
                                      style: TextStyles.bodySmall.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorsManager.primaryGreen.withOpacity(
                                    0.05,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.r),
                                    topRight: Radius.circular(12.r),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.history,
                                      size: 18.r,
                                      color: ColorsManager.primaryGreen,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      "عمليات البحث السابقة",
                                      style: TextStyles.bodySmall.copyWith(
                                        color: ColorsManager.primaryGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: _hideSearchHistory,
                                      child: Icon(
                                        Icons.close,
                                        size: 18.r,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // History List
                              Flexible(
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount:
                                      state.hisoryItems.length > 6
                                          ? 6
                                          : state.hisoryItems.length,
                                  separatorBuilder:
                                      (context, index) => Divider(
                                        height: 1.h,
                                        color: Colors.grey[200],
                                        indent: 16.w,
                                        endIndent: 16.w,
                                      ),
                                  itemBuilder: (context, index) {
                                    final item = state.hisoryItems[index];
                                    return InkWell(
                                      onTap: () {
                                        _hideSearchHistory();
                                        context.pushNamed(
                                          Routes.publicSearchSCreen,
                                          arguments: item.title,
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 12.h,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 32.w,
                                              height: 32.w,
                                              decoration: BoxDecoration(
                                                color: ColorsManager
                                                    .primaryGreen
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: Icon(
                                                Icons.search,
                                                size: 16.r,
                                                color:
                                                    ColorsManager.primaryGreen,
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.title,
                                                    style: TextStyles.bodyMedium
                                                        .copyWith(
                                                          color:
                                                              ColorsManager
                                                                  .primaryText,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 2.h),
                                                  Text(
                                                    "${item.date} - ${item.time}",
                                                    style: TextStyles.bodySmall
                                                        .copyWith(
                                                          color:
                                                              ColorsManager
                                                                  .secondaryText,
                                                          fontSize: 11.sp,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            GestureDetector(
                                              onTap: () {
                                                searchHistoryCubit.removeItem(
                                                  index,
                                                  searchCategory:
                                                      HistoryPrefs
                                                          .enhancedPublicSearch,
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4.r),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 16.r,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Show more button if there are more than 6 items
                              if (state.hisoryItems.length > 6)
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.grey[200]!,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      _hideSearchHistory();
                                      // Navigate to full search history page if needed
                                    },
                                    child: Text(
                                      "عرض المزيد",
                                      style: TextStyles.bodySmall.copyWith(
                                        color: ColorsManager.primaryGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSearchHistory() {
    setState(() {
      showSearch = false;
    });
    _removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    SaveHadithDailyRepo().getHadith();
    return SafeArea(
      top: false,
      child: DoubleTapToExitApp(
        myScaffoldScreen: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: ColorsManager.secondaryBackground,
            body: _buildBody(),
          ),
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
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: HomeScreenShimmer(),
    );
  }

  Widget _buildSuccessState(GetLivraryStatisticsSuccess state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (showSearch) {
          _hideSearchHistory();
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          if (showSearch) _hideSearchHistory();
        },
        child: CustomScrollView(
          slivers: [
            _buildHeaderSection(),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            _buildSearchBarSection(),
            _buildDailyHadithSection(),
            _buildDividerSection(),
            _buildStatisticsSection(state),
            _buildDividerSection(),
            _buildCategoriesSection(state),
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox.shrink();
  }

  Widget _buildHeaderSection() {
    return BuildHeaderAppBar(
      home: true,
      title: 'مشكاة المصابيح',
      description: 'مكتبة مشكاة الإسلامية',
    );
  }

  Widget _buildSearchBarSection() {
    return SliverToBoxAdapter(
      child: Container(
        key: _searchKey,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: SearchBarWidget(
          onTap: () {
            if (!showSearch) {
              setState(() {
                showSearch = true;
              });
              context.read<SearchHistoryCubit>().emitHistorySearch(
                searchCategory: HistoryPrefs.enhancedPublicSearch,
              );
              _showSearchHistory();
            } else {
              _hideSearchHistory();
            }
          },
          controller: _controller,
          onSearch: (query) {
            _hideSearchHistory();

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
          },
        ),
      ),
    );
  }

  Widget _buildDailyHadithSection() {
    return SliverToBoxAdapter(
      child: HadithOfTheDayCard(repo: SaveHadithDailyRepo()),
    );
  }

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

  Widget _buildDividerSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
        child: _buildIslamicSeparator(),
      ),
    );
  }

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
          SizedBox(
            width: 100,
            height: 100,
            child: RandomAhadithBlocBuilder())
        ],
      ),
    );
  }

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

  void _navigateToLibrary(String screenName, String screenId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LibraryScreen(name: screenName, id: screenId),
      ),
    );
  }
}

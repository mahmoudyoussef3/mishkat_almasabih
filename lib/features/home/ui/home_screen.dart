import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/networking/api_constants.dart'
    show bookNamesArabic;
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/widgets/double_tap_to_exot.dart';
import 'package:mishkat_almasabih/core/widgets/miskat_drawer.dart';
import 'package:mishkat_almasabih/features/book_data/data/models/book_data_model.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_library_statistics_cubit.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/daily_hadith_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/search_bar_widget.dart';
import 'package:mishkat_almasabih/features/library_books_screen.dart';
import 'package:mishkat_almasabih/features/random_ahadith/ui/widgets/random_ahadith_bloc_builder.dart';
import 'package:mishkat_almasabih/features/library/ui/widgets/book_card.dart';
import 'package:mishkat_almasabih/features/library/ui/widgets/book_card_shimmer.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/repos/shared_pref_history_item_repo.dart';
import 'package:mishkat_almasabih/features/search/search_screen/logic/cubit/search_history_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/styles.dart';

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
          child: SafeArea(
            child: Scaffold(
              drawer:MishkatDrawer(),

              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: ColorsManager.primaryGreen,
                foregroundColor: ColorsManager.secondaryBackground,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BlocProvider(
                            create:
                                (context) => getIt<GetLibraryStatisticsCubit>(),
                            child: LibraryBooksScreen(),
                          ),
                    ),
                  );
                },
                label: Row(
                  children: [
                    Text('المكتبة', style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: 4.w),

                    Icon(Icons.local_library_sharp),
                  ],
                ),
              ),
              backgroundColor: ColorsManager.secondaryBackground,
              body: _buildBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return _buildSuccessState();
  }

  Widget _buildSuccessState() {
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
            _buildBooksSection(),
            _buildDividerSection(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    Text(
                      'أحاديث عامة',

                      style: TextStyles.headlineMedium.copyWith(
                        color: ColorsManager.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.h),
                  ],
                ),
              ),
            ),
            _buildRandomAhadith(),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksSection() {
    return SliverToBoxAdapter(
      child: BlocBuilder<GetLibraryStatisticsCubit, GetLibraryStatisticsState>(
        builder: (context, state) {
          if (state is GetLivraryStatisticsLoading) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: SizedBox(
                height: 240.h, // ارتفاع مناسب للكاردات
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 140.w,
                      child: const BookCardShimmer(),
                    );
                  },
                ),
              ),
            );
          } else if (state is GetLivraryStatisticsSuccess) {
            var books = state.statisticsResponse.statistics.topBooks;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الكتب الأكثر رواجا',

                    style: TextStyles.headlineMedium.copyWith(
                      color: ColorsManager.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 240.h, // ارتفاع مناسب للكاردات
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: books.length,
                      separatorBuilder:
                          (context, index) => SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final book = books[index];

                        return SizedBox(
                          width: 160.w,
                          child: BookCard(
                            book: Book(
                              bookName: book.name,
                              bookSlug:
                                  booksMap[bookNamesArabic[book.name]] ?? '',
                              writerName: book.name,
                              chapters_count: book.chapters,
                              hadiths_count: book.hadiths,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return BuildHeaderAppBar(
      home: true,
      bottomNav: true,
      title: 'مشكاة المصابيح',
      description: 'مكتبة مشكاة الإسلامية',
    );
  }

  final Map<String, String> booksMap = {
    'صحيح البخاري': 'sahih-bukhari',
    'صحيح مسلم': 'sahih-muslim',
    'سنن أبي داود': 'abu-dawood',
    'سنن الترمذي': 'al-tirmidhi',
    'سنن النسائي': 'sunan-nasai',
    'سنن ابن ماجة': 'ibn-e-majah',
    'موطأ مالك': 'malik',
    'مسند أحمد': 'musnad-ahmad',
    'سنن الدارمي': 'darimi',
    'بلوغ المرام': 'bulugh_al_maram',
    'رياض الصالحين': 'riyad_assalihin',
    'مشكات المصابيح': 'mishkat',
    'الأربعون النووية': 'nawawi40',
    'الأربعون القدسية': 'qudsi40',
    'أربعون ولي الله الدهلوي': 'shahwaliullah40',
    'الأدب المفرد': 'aladab_almufrad',
    'الشمائل المحمدية': 'shamail_muhammadiyah',
    'حصن المسلم': 'hisnul_muslim',
  };

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

  Widget _buildDividerSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
        child: _buildIslamicSeparator(),
      ),
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

  Widget _buildRandomAhadith() {
    return RandomAhadithBlocBuilder();
  }
}

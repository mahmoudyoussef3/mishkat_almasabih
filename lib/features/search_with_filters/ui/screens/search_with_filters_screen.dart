import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';
import 'package:mishkat_almasabih/core/widgets/double_tap_to_exot.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/search_bar_widget.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/repos/shared_pref_history_item_repo.dart';
import 'package:mishkat_almasabih/features/search/search_screen/logic/cubit/search_history_cubit.dart';
import 'package:mishkat_almasabih/features/search/search_screen/ui/widgets/empty_history.dart';
import 'package:mishkat_almasabih/features/search/search_screen/ui/widgets/history_list.dart';
import 'package:mishkat_almasabih/features/search/search_screen/ui/widgets/history_shimmer.dart';

class SearchWithFiltersScreen extends StatefulWidget {
  const SearchWithFiltersScreen({super.key});

  @override
  State<SearchWithFiltersScreen> createState() =>
      _SearchWithFiltersScreenState();
}

class _SearchWithFiltersScreenState extends State<SearchWithFiltersScreen> {
  List<HistoryItem> _items = [];

  String? _selectedBook;
  String? _selectedAuthenticity;
  String? _selectedCategory;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController chapterController = TextEditingController();
  final TextEditingController narratorController = TextEditingController();

  // الكتب
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

  // الدرجات
  final Map<String, String> gradesMap = {
    'صحيح': 'sahih',
    'حسن': 'hasan',
    'ضعيف': 'daif',
  };

  // الأقسام
  final Map<String, String> categoriesMap = {
    'الأربعون': 'arbaain',
    'الكتب التسعة': 'kutub_tisaa',
    'الأدب والآداب': 'adab',
  };

  Future<void> addItemToHistory(HistoryItem historyItem) async {
    final existingIndex = _items.indexWhere(
      (item) => item.title == historyItem.title,
    );
    if (existingIndex != -1) {
      _items[existingIndex] = historyItem;
    } else {
      _items.add(historyItem);
    }
    await HistoryPrefs.saveHistory(_items, HistoryPrefs.filteredSearch);
    context.read<SearchHistoryCubit>().emitHistorySearch(
      searchCategory: HistoryPrefs.filteredSearch,
    );
  }

  Future<void> removeItem(int index) async {
    _items.removeAt(index);
    await HistoryPrefs.saveHistory(_items, HistoryPrefs.filteredSearch);
    context.read<SearchHistoryCubit>().emitHistorySearch(
      searchCategory: HistoryPrefs.filteredSearch,
    );
  }

  Future<void> clearAll() async {
    await HistoryPrefs.clearHistory(HistoryPrefs.filteredSearch);
    context.read<SearchHistoryCubit>().emitHistorySearch(
      searchCategory: HistoryPrefs.filteredSearch,
    );
  }

  String formatDateTime(DateTime dateTime) {
    final date =
        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    final time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return "$time - $date";
  }

  bool showFilters = false;
@override
void initState() {
  super.initState();
  Future.microtask(() {
    if (mounted) {
      context.read<SearchHistoryCubit>().emitHistorySearch(
        searchCategory: HistoryPrefs.filteredSearch,
      );
    }
  });
}

  @override
  Widget build(BuildContext context) {


    return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ColorsManager.secondaryBackground,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryPurple,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // الخلفية
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.05,
                            child: Image.asset(
                              'assets/images/islamic_pattern.jpg',
                              repeat: ImageRepeat.repeat,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
          
                        Center(
                          child: Text(
                            "البحث",
                            style: TextStyles.displaySmall.copyWith(
                              color: ColorsManager.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32.sp,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          
                  SizedBox(height: 20.h),
          
                  /// Search Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      children: [
                        SearchBarWidget(
                          hintText: 'ابحث في الأحاديث...',
                          controller: searchController,
                          onSearch: (query) {
                            final now = DateTime.now();
                            addItemToHistory(
                              HistoryItem(
                                title: query.trim(),
                                date: formatDateTime(now).split(' - ')[1],
                                time: formatDateTime(now).split(' - ')[0],
                              ),
                            );
                context.pushNamed(
                  Routes.publicSearchSCreen,
                  arguments: query.trim(),
                );
                       
                          },
                        ),
          
                        SizedBox(height: 20.h),
          
         
                        SizedBox(height: 12.h),
          
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
                              onPressed: clearAll,
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
                      ],
                    ),
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
                        _items = List.from(state.hisoryItems);
                        return _items.isNotEmpty
                            ? HistoryList(
                              items: _items,
                              onRemove: removeItem,
                              onClearAll: clearAll,
                            )
                            : const EmptyHistory();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }



  
}

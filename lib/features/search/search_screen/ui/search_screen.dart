import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/search_bar_widget.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/repos/shared_pref_history_item_repo.dart';
import 'package:mishkat_almasabih/features/search/search_screen/logic/cubit/search_history_cubit.dart';
import 'package:mishkat_almasabih/features/search/search_screen/ui/widgets/history_list.dart';
import 'package:mishkat_almasabih/features/search/search_screen/ui/widgets/history_shimmer.dart';
import 'package:mishkat_almasabih/features/search/search_screen/ui/widgets/empty_history.dart';
/*class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<HistoryItem> _items = [];
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addItemToHistory(HistoryItem historyItem) async {
    final existingIndex = _items.indexWhere(
      (item) => item.title == historyItem.title,
    );
    if (existingIndex != -1) {
      _items[existingIndex] = historyItem;
    } else {
      _items.add(historyItem);
    }
    await HistoryPrefs.saveHistory(_items);
    context.read<SearchHistoryCubit>().emitHistorySearch();
  }

  Future<void> _removeItem(int index) async {
    _items.removeAt(index);
    await HistoryPrefs.saveHistory(_items);
    context.read<SearchHistoryCubit>().emitHistorySearch();
  }

  Future<void> _clearAll() async {
    await HistoryPrefs.clearHistory();
    context.read<SearchHistoryCubit>().emitHistorySearch();
  }

  String _formatDateTime(DateTime dateTime) {
    final date =
        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    final time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return "$time - $date";
  }

  @override
  Widget build(BuildContext context) {
    context.read<SearchHistoryCubit>().emitHistorySearch();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: CustomScrollView(
          slivers: [
            const BuildHeaderAppBar(title: 'البحث'),
            SliverToBoxAdapter(child: SizedBox(height: 20.h)),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SearchBarWidget(
                  controller: _controller,
                  onSearch: (query) {
                    final trimmedQuery = query.trim();
                    if (trimmedQuery.isNotEmpty) {
                      final now = DateTime.now();
                      _addItemToHistory(
                        HistoryItem(
                          title: trimmedQuery,
                          date: _formatDateTime(now).split(' - ')[1],
                          time: _formatDateTime(now).split(' - ')[0],
                        ),
                      );
                      context.pushNamed(Routes.publicSearchSCreen,arguments: trimmedQuery);
                    }
                  },
                ),
              ),
            ),

            BlocBuilder<SearchHistoryCubit, SearchHistoryState>(
              builder: (context, state) {
                if (state is SearchHistoryLoading) {
                  return const HistoryShimmer();
                } else if (state is SearchHistoryError) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Text("خطأ أثناء تحميل السجل")),
                  );
                } else if (state is SearchHistorySuccess) {
                  _items = List.from(state.hisoryItems);
                  return _items.isNotEmpty
                      ? HistoryList(
                        items: _items,
                        onRemove: _removeItem,
                        onClearAll: _clearAll,
                      )
                      : const EmptyHistory();
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}*/
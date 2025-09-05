import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/repos/shared_pref_history_item_repo.dart';

part 'search_history_state.dart';

class SearchHistoryCubit extends Cubit<SearchHistoryState> {

  SearchHistoryCubit() : super(SearchHistoryInitial());


  Future<void> emitHistorySearch({required String searchCategory}) async {
    emit(SearchHistoryLoading());

    final result = await HistoryPrefs.loadHistory(searchCategory);
    result.fold(
      (error) => emit(SearchHistoryError(error)),
      (history) => emit(SearchHistorySuccess(history)),
    );
  }

  /// إضافة عنصر
  Future<void> addItem(HistoryItem item, {required String searchCategory}) async {
    final result = await HistoryPrefs.loadHistory(searchCategory);

    result.fold(
      (error) => emit(SearchHistoryError(error)),
      (history) async {
        final items = List<HistoryItem>.from(history);

        final existingIndex = items.indexWhere((e) => e.title == item.title);
        if (existingIndex != -1) {
          items[existingIndex] = item;
        } else {
          items.add(item);
        }

        await HistoryPrefs.saveHistory(items, searchCategory);
        emit(SearchHistorySuccess(items));
      },
    );
  }

  /// حذف عنصر
  Future<void> removeItem(int index, {required String searchCategory}) async {
    final result = await HistoryPrefs.loadHistory(searchCategory);

    result.fold(
      (error) => emit(SearchHistoryError(error)),
      (history) async {
        final items = List<HistoryItem>.from(history);

        if (index >= 0 && index < items.length) {
          items.removeAt(index);
          await HistoryPrefs.saveHistory(items, searchCategory);
        }

        emit(SearchHistorySuccess(items));
      },
    );
  }

  /// مسح الكل
  Future<void> clearAll({required String searchCategory}) async {
    await HistoryPrefs.clearHistory(searchCategory);
    emit(SearchHistorySuccess([]));
  }
}


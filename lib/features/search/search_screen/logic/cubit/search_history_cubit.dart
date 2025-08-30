import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/repos/shared_pref_history_item_repo.dart';

part 'search_history_state.dart';

class SearchHistoryCubit extends Cubit<SearchHistoryState> {

  SearchHistoryCubit() : super(SearchHistoryInitial());
  Future<void> emitHistorySearch() async {
    final result = await HistoryPrefs.loadHistory();

    result.fold(
      (error) =>emit(SearchHistoryError(error)),
      (history) => emit(SearchHistorySuccess(history)),
    );
  }
}

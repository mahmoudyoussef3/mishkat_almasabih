part of 'search_history_cubit.dart';

@immutable
sealed class SearchHistoryState {}

final class SearchHistoryInitial extends SearchHistoryState {}

final class SearchHistorySuccess extends SearchHistoryState {
  final List<HistoryItem> hisoryItems;
  SearchHistorySuccess(this.hisoryItems);
}

final class SearchHistoryLoading extends SearchHistoryState {}

final class SearchHistoryError extends SearchHistoryState {
    final String errMessage;
  SearchHistoryError(this.errMessage);
}

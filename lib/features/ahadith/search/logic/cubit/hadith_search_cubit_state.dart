part of 'hadith_search_cubit_cubit.dart';

@immutable
sealed class HadithSearchCubitState {}

final class HadithSearchCubitInitial extends HadithSearchCubitState {}

final class HadithSearchLoading extends HadithSearchCubitState {}

final class HadithSearchSuccess extends HadithSearchCubitState {
  final SearchResponse _searchResponse;
  HadithSearchSuccess(this._searchResponse);
}

final class HadithSearchFailure extends HadithSearchCubitState {
  final String errMessage;
  HadithSearchFailure(this.errMessage);
}

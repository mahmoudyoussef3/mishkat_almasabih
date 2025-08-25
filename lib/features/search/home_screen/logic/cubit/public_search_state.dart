part of 'public_search_cubit.dart';

@immutable
sealed class PublicSearchState {}

final class PublicSearchInitial extends PublicSearchState {}

final class PublicSearchLoading extends PublicSearchState {}

final class PublicSearchSuccess extends PublicSearchState {
  final SearchResponse searchResponse;
  PublicSearchSuccess(this.searchResponse);
}

final class PublicSearchFailure extends PublicSearchState {
  final String message;
  PublicSearchFailure(this.message);
}

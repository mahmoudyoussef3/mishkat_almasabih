part of 'enhanced_search_cubit.dart';

@immutable
sealed class EnhancedSearchState {}

final class EnhancedSearchInitial extends EnhancedSearchState {}
final class EnhancedSearchLoading extends EnhancedSearchState {}
final class EnhancedSearchLoaded extends EnhancedSearchState {
  final EnhancedSearch enhancedSearch;
  EnhancedSearchLoaded(this.enhancedSearch);
}
final class EnhancedSearchError extends EnhancedSearchState {
  final String message;
  EnhancedSearchError(this.message);
}

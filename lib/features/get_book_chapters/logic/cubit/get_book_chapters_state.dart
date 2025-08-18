part of 'get_book_chapters_cubit.dart';

@immutable
sealed class GetBookChaptersState {}

final class GetBookChaptersInitial extends GetBookChaptersState {}

final class GetBookChaptersLoading extends GetBookChaptersState {}

final class GetBookChaptersSuccess extends GetBookChaptersState {
  final BookChaptersModel bookChaptersModel;
  GetBookChaptersSuccess(this.bookChaptersModel);
}

final class GetBookChaptersFailure extends GetBookChaptersState {
  final String? errorMessage;
  GetBookChaptersFailure(this.errorMessage);
}

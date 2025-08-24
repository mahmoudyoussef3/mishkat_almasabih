part of 'user_bookmarks_cubit.dart';

@immutable
sealed class GetBookmarksState {}

final class GetBookmarksInitial extends GetBookmarksState {}

final class GetBookmarksLoading extends GetBookmarksState {}

final class UserBookmarksSuccess extends GetBookmarksState {
  final List<Bookmark> bookmarks;
  UserBookmarksSuccess(this.bookmarks);
}

final class GetBookmarksFailure extends GetBookmarksState {
  final String message;
  GetBookmarksFailure(this.message);
}


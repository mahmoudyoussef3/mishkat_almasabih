part of 'user_bookmarks_cubit.dart';

@immutable
sealed class UserBookmarksState {}

final class UserBookmarksInitial extends UserBookmarksState {}

/// ------- Get Bookmarks -------
final class UserBookmarksLoading extends UserBookmarksState {}

final class UserBookmarksSuccess extends UserBookmarksState {
  final List<Bookmark> bookmarks;
  UserBookmarksSuccess(this.bookmarks);
}

final class UserBookmarksFailure extends UserBookmarksState {
  final String message;
  UserBookmarksFailure(this.message);
}

/// ------- Add Bookmark -------
final class AddBookmarkLoading extends UserBookmarksState {}

final class AddBookmarkSuccess extends UserBookmarksState {
  final AddBookmarkResponse addBookmarkResponse;
  AddBookmarkSuccess(this.addBookmarkResponse);
}

final class AddBookmarkFailure extends UserBookmarksState {
  final String message;
  AddBookmarkFailure(this.message);
}

/// ------- Delete Bookmark -------
final class DeleteBookmarkLoading extends UserBookmarksState {}

final class DeleteBookmarkSuccess extends UserBookmarksState {
  final AddBookmarkResponse addBookmarkResponse;
  DeleteBookmarkSuccess(this.addBookmarkResponse);
}

final class DeleteBookmarkFailure extends UserBookmarksState {
  final String message;
  DeleteBookmarkFailure(this.message);
}

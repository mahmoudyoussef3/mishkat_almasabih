import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_response.dart';
import 'package:mishkat_almasabih/features/bookmark/data/repos/book_mark_repo.dart';

part 'user_bookmarks_state.dart';

class UserBookmarksCubit extends Cubit<UserBookmarksState> {
  final BookMarkRepo _bookMarkRepo;
  UserBookmarksCubit(this._bookMarkRepo) : super(UserBookmarksInitial());

  Future<void> getUserBookmarks() async {
    emit(UserBookmarksLoading());
    final result = await _bookMarkRepo.getUserBookMarks();

    result.fold(
      (l) => emit(UserBookmarksFailure(l.apiErrorModel.msg.toString())),
      (r) => emit(UserBookmarksSuccess(r.bookmarks!)),
    );
  }

  Future<void> addBookmark(Bookmark body) async {
    emit(AddBookmarkLoading());
    final result = await _bookMarkRepo.addBookmark(body);

    result.fold(
      (l) => emit(AddBookmarkFailure(l.apiErrorModel.msg.toString())),
      (r) => emit(AddBookmarkSuccess(r)),
    );
  }

  Future<void> delete(int id) async {
    emit(DeleteBookmarkLoading());
    final result = await _bookMarkRepo.deleteBookMark(id);

    result.fold(
      (l) => emit(DeleteBookmarkFailure(l.apiErrorModel.msg.toString())),
      (r) => emit(DeleteBookmarkSuccess(r)),
    );
  }
}

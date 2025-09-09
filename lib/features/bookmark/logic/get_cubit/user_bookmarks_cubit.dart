import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/core/cache/cache_mixin.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/data/repos/book_mark_repo.dart';

part 'user_bookmarks_state.dart';

class GetBookmarksCubit extends Cubit<GetBookmarksState> with CacheMixin {
  final BookMarkRepo _bookMarkRepo;
  GetBookmarksCubit(this._bookMarkRepo) : super(GetBookmarksInitial());

  Future<void> getUserBookmarks({bool forceRefresh = false}) async {
    const cacheKey = 'user_bookmarks';

    await loadWithCacheAndRefresh<BookMarkResponse>(
      cacheKey: cacheKey,
      apiCall: () async {
        final result = await _bookMarkRepo.getUserBookMarks();
        return result.fold(
          (error) => throw Exception(error.apiErrorModel.msg.toString()),
          (data) => data,
        );
      },
      fromJson: (json) => BookMarkResponse.fromJson(json),
      toJson: (data) => data.toJson(),
      onSuccess: (data) => emit(UserBookmarksSuccess(data.bookmarks!)),
      onError: (error) => emit(GetBookmarksFailure(error)),
      loadingState: () => GetBookmarksLoading(),
      forceRefresh: forceRefresh,
      customCacheDuration: 15, // 15 minutes cache for user bookmarks
    );
  }
}

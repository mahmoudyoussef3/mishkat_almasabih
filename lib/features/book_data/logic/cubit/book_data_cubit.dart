import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/core/cache/cache_mixin.dart';
import 'package:mishkat_almasabih/features/book_data/data/models/book_data_model.dart';
import 'package:mishkat_almasabih/features/book_data/data/repos/book_data_repo.dart';

part 'book_data_state.dart';

class BookDataCubit extends Cubit<BookDataState> with CacheMixin {
  GetBookDataRepo bookDataRepo;
  BookDataCubit(this.bookDataRepo) : super(BookDataInitial());

  Future<void> emitGetBookData(String id, {bool forceRefresh = false}) async {
    final cacheKey = CacheService.generateCacheKey('book_data', {
      'categoryId': id,
    });

    await loadWithCacheAndRefresh<CategoryResponse>(
      cacheKey: cacheKey,
      apiCall: () async {
        log('Fetching book data for category: $id');
        final result = await bookDataRepo.getBookData(id);
        return result.fold(
          (error) => throw Exception(error.apiErrorModel.msg!),
          (data) => data,
        );
      },
      fromJson: (json) => CategoryResponse.fromJson(json),
      toJson: (data) => data.toJson(),
      onSuccess: (data) => emit(BookDataSuccess(data)),
      onError: (error) => emit(BookDataFailure(error)),
      loadingState: () => BookDataLoading(),
      forceRefresh: forceRefresh,
      customCacheDuration: 60, // 1 hour cache for book data
    );
  }
}

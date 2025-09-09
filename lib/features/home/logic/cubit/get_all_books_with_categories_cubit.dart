import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/core/cache/cache_mixin.dart';
import 'package:mishkat_almasabih/features/home/data/models/book_model.dart';
import 'package:mishkat_almasabih/features/home/data/repos/get_all_books_with_categories_repo.dart';

part 'get_all_books_with_categories_state.dart';

class GetAllBooksWithCategoriesCubit
    extends Cubit<GetAllBooksWithCategoriesState>
    with CacheMixin {
  final GetAllBooksWithCategoriesRepo _allBooksWithCategoriesRepo;
  GetAllBooksWithCategoriesCubit(this._allBooksWithCategoriesRepo)
    : super(GetAllBooksWithCategoriesInitial());

  Future<void> emitGetAllBooksWithCategories({
    bool forceRefresh = false,
  }) async {
    const cacheKey = 'all_books_with_categories';

    await loadWithCacheAndRefresh<BooksResponse>(
      cacheKey: cacheKey,
      apiCall: () async {
        final response =
            await _allBooksWithCategoriesRepo.getAllBooksWithCategoriesRepo();
        return response.fold(
          (error) => throw Exception(error.apiErrorModel.msg.toString()),
          (data) => data,
        );
      },
      fromJson: (json) => BooksResponse.fromJson(json),
      toJson: (data) => data.toJson(),
      onSuccess: (data) => emit(GetAllBooksWithCategoriesSuccess(data)),
      onError: (error) => emit(GetAllBooksWithCategoriesError(error)),
      loadingState: () => GetAllBooksWithCategoriesLoading(),
      forceRefresh: forceRefresh,
      customCacheDuration: 60, // 1 hour cache for books data
    );
  }
}

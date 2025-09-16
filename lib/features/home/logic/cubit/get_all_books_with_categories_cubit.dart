import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:mishkat_almasabih/features/home/data/models/book_model.dart';
import 'package:mishkat_almasabih/features/home/data/repos/get_all_books_with_categories_repo.dart';

part 'get_all_books_with_categories_state.dart';

class GetAllBooksWithCategoriesCubit
    extends Cubit<GetAllBooksWithCategoriesState> {
  final GetAllBooksWithCategoriesRepo _allBooksWithCategoriesRepo;

  GetAllBooksWithCategoriesCubit(this._allBooksWithCategoriesRepo)
    : super(GetAllBooksWithCategoriesInitial());

  /// Load books with caching logic
  Future<void> emitGetAllBooksWithCategories({
    bool forceRefresh = false,
  }) async {
    emit(GetAllBooksWithCategoriesLoading());

    try {
      
      final response =
          await _allBooksWithCategoriesRepo.getAllBooksWithCategoriesRepo();




      response.fold(
        (error) {
          log('❌ API Error: ${error.apiErrorModel.msg}');
          emit(
            GetAllBooksWithCategoriesError(error.apiErrorModel.msg.toString()),
          );
        },
        (apiData) async {
          log('✅ Books fetched from API successfully');

          emit(GetAllBooksWithCategoriesSuccess(apiData));
        },
      );
    } catch (e) {
      log('❌ Unexpected error in books cubit: $e');
      emit(GetAllBooksWithCategoriesError('حدث خطأ غير متوقع: $e'));
    }
  }

  /// Force refresh data (clear cache and fetch new)
  Future<void> forceRefresh() async {
    log('🔄 Force refreshing books...');
    await emitGetAllBooksWithCategories(forceRefresh: true);
  }

  /// Clear books cache
  Future<void> clearCache() async {
    log('🗑️ Books cache cleared');
  }
}

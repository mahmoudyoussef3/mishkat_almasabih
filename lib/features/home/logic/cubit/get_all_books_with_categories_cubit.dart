import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/home/data/models/book_model.dart';
import 'package:mishkat_almasabih/features/home/data/repos/cache_service.dart';
import 'package:mishkat_almasabih/features/home/data/repos/get_all_books_with_categories_repo.dart';

part 'get_all_books_with_categories_state.dart';

class GetAllBooksWithCategoriesCubit
    extends Cubit<GetAllBooksWithCategoriesState> {
  final GetAllBooksWithCategoriesRepo _allBooksWithCategoriesRepo;
  final CacheService _cacheService = CacheService.instance;

  GetAllBooksWithCategoriesCubit(this._allBooksWithCategoriesRepo)
      : super(GetAllBooksWithCategoriesInitial());

  /// Load books with caching logic
  Future<void> emitGetAllBooksWithCategories({bool forceRefresh = false}) async {
    emit(GetAllBooksWithCategoriesLoading());
    
    try {
      BooksResponse? data;

      if (!forceRefresh) {
        // Try to get from cache first
        log('📖 Attempting to load books from cache...');
        data = await _cacheService.getBooks();
        
        if (data != null) {
          log('✅ Books loaded from cache successfully');
          emit(GetAllBooksWithCategoriesSuccess(data));
          return;
        }
      }

      // If cache miss or force refresh, fetch from API
      log('🌐 Fetching books from API...');
      final response = await _allBooksWithCategoriesRepo.getAllBooksWithCategoriesRepo();

      response.fold(
        (error) {
          log('❌ API Error: ${error.apiErrorModel.msg}');
          emit(GetAllBooksWithCategoriesError(error.apiErrorModel.msg.toString()));
        },
        (apiData) async {
          log('✅ Books fetched from API successfully');
          
          // Cache the new data
          final cacheResult = await _cacheService.saveBooks(apiData);
          log('💾 Cache save result: $cacheResult');
          
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
    await _cacheService.clearBooksCache();
    await emitGetAllBooksWithCategories(forceRefresh: true);
  }

  /// Clear books cache
  Future<void> clearCache() async {
    await _cacheService.clearBooksCache();
    log('🗑️ Books cache cleared');
  }
}
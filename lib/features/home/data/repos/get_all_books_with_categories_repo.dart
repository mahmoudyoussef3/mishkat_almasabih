import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:mishkat_almasabih/features/home/data/models/book_model.dart';

class GetAllBooksWithCategoriesRepo {
  final ApiService _apiService;

  GetAllBooksWithCategoriesRepo(this._apiService);
  final _bookResponseCache = GenericCache<BooksResponse>(
    cacheKey: "book_response",
    fromJson: (json) => BooksResponse.fromJson(json),
  );

  Future<Either<ErrorHandler, BooksResponse>>
  getAllBooksWithCategoriesRepo() async {
    try {
      final cache = await _bookResponseCache.getData();
      if (cache != null) {
        log("cache bookd with categories is $cache");
        return Right(cache);
      }
      final response = await _apiService.getAllBooksWithCategories();
      await _bookResponseCache.saveData(response);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}

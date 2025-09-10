import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:mishkat_almasabih/features/book_data/data/models/book_data_model.dart';

class GetBookDataRepo {
  final ApiService _apiService;

  GetBookDataRepo(this._apiService);

  final _bookDataCache = GenericCache<CategoryResponse>(
    cacheKey: "categoryResponse",
    fromJson: (json) => CategoryResponse.fromJson(json),
  );

  Future<Either<ErrorHandler, CategoryResponse>> getBookData(String id) async {
    try {
      final cache = await _bookDataCache.getData();
      if (cache != null) {
        return Right(cache);
      }
      final response = await _apiService.getBookData(id);

    await  _bookDataCache.saveData(response);
      return Right(response);
    } catch (error) {
      log(error.toString());

      return Left(ErrorHandler.handle(error));
    }
  }
}

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_error_model.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/collection_model.dart';

import 'package:mishkat_almasabih/features/chapters/data/models/chapters_model.dart';

class BookChaptersRepo {
  final ApiService _apiService;
  BookChaptersRepo(this._apiService);

  Future<Either<ApiErrorModel, ChaptersModel>> getBookChapters(
    String bookSlug,
  ) async {
    try {
      final cacheKey = CacheKeys.chaptersResponse + bookSlug;

      final cachedData = await GenericCacheService.instance
          .getData<ChaptersModel>(
            key: cacheKey,
            fromJson: (json) => ChaptersModel.fromJson(json),
          );

      if (cachedData != null) {
        log('📂 Loaded Ahadith from cache for $id ');
        return Right(cachedData);
      }

      final response = await _apiService.getBookChapters(bookSlug);

      await GenericCacheService.instance.saveData<ChaptersModel>(
        key: cacheKey,
        data: response,
        toJson: (data) => data.toJson(),
        cacheExpirationHours: 100,
      );
      return Right(response);
    } catch (error) {
      log(error.toString());
      return Left(ErrorHandler.handle(error));
    }
  }
}
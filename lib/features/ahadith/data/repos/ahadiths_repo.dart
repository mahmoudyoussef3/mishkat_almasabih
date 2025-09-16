import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:mishkat_almasabih/features/ahadith/data/models/ahadiths_model.dart';
import 'package:mishkat_almasabih/features/ahadith/data/models/local_books_model.dart';

class AhadithsRepo {
  AhadithsRepo(this._apiService);
  final ApiService _apiService;

  Future<Either<ErrorHandler, HadithResponse>> getAhadith({
    required String bookSlug,
    required int chapterId,
  }) async {
    try {
      final cacheKey =
          '${CacheKeys.remoteHadithResponse}_${bookSlug}_$chapterId';

      final cachedData = await GenericCacheService.instance
          .getData<HadithResponse>(
            key: cacheKey,
            fromJson: (json) => HadithResponse.fromJson(json),
          );

      if (cachedData != null) {
        log('📂 Loaded Ahadith from cache for $bookSlug / $chapterId');
        return Right(cachedData);
      }

      final response = await _apiService.getChapterAhadiths(
        bookSlug,
        chapterId,
      );

      await GenericCacheService.instance.saveData<HadithResponse>(
        key: cacheKey,
        data: response,
        toJson: (data) => data.toJson(),
        cacheExpirationHours: 100, 
      );

      log(
        '🌍 Loaded Ahadith from API and cached it for $bookSlug / $chapterId',
      );
      return Right(response);
    } catch (e) {
      log(e.toString());
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<ErrorHandler, LocalHadithResponse>> getLocalAhadith({
    required String bookSlug,
    required int chapterId,
  }) async {
    try {
      final cacheKey =
          '${CacheKeys.localHadithResponse}_${bookSlug}_$chapterId';

      final cachedData = await GenericCacheService.instance
          .getData<LocalHadithResponse>(
            key: cacheKey,
            fromJson: (json) => LocalHadithResponse.fromJson(json),
          );

      if (cachedData != null) {
        log('📂 Loaded Local Ahadith from cache');
        return Right(cachedData);
      }

      final response = await _apiService.getLocalChapterAhadiths(
        bookSlug,
        chapterId,
      );

      await GenericCacheService.instance.saveData<LocalHadithResponse>(
        key: cacheKey,
        data: response,
        toJson: (data) => data.toJson(),
        
      );

      log('🌍 Loaded Local Ahadith from API and cached it');
      return Right(response);
    } catch (e) {
      log(e.toString());
      return Left(ErrorHandler.handle(e));
    }
  }

  /// 📦 Get Three Books Local Ahadith (with caching)
  Future<Either<ErrorHandler, LocalHadithResponse>> getThreeAhadith({
    required String bookSlug,
    required int chapterId,
  }) async {
    try {
      final cacheKey =
          '${CacheKeys.localHadithResponse}_${bookSlug}_$chapterId';

      final cachedData = await GenericCacheService.instance
          .getData<LocalHadithResponse>(
            key: cacheKey,
            fromJson: (json) => LocalHadithResponse.fromJson(json),
          );

      if (cachedData != null) {
        log('📂 Loaded Local Ahadith from cache');
        return Right(cachedData);
      }

      final response = await _apiService.getThreeBooksLocalChapterAhadiths(
        bookSlug,
        chapterId,
      );

      await GenericCacheService.instance.saveData<LocalHadithResponse>(
        key: cacheKey,
        data: response,
        toJson: (data) => data.toJson(),
      );

      log('🌍 Loaded Local Ahadith from API and cached it');
      return Right(response);
    } catch (e) {
      log(e.toString());
      return Left(ErrorHandler.handle(e));
    }
  }
}
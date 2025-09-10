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

  // 🔹 كاش لكل نوع موديل
  final _hadithCache = GenericCache<HadithResponse>(
    cacheKey: "hadith_response",
    fromJson: (json) => HadithResponse.fromJson(json),
  );

  final _localHadithCache = GenericCache<LocalHadithResponse>(
    cacheKey: "local_hadith_response",
    fromJson: (json) => LocalHadithResponse.fromJson(json),
  );

  final _threeBooksCache = GenericCache<LocalHadithResponse>(
    cacheKey: "three_books_hadith_response",
    fromJson: (json) => LocalHadithResponse.fromJson(json),
  );

  /// 📦 Get Ahadith (with caching)
  Future<Either<ErrorHandler, HadithResponse>> getAhadith({
    required  bookSlug,
    required  chapterId,
  }) async {
    try {
      // 1) حاول تجيب من الكاش
      final cached = await _hadithCache.getData();
      if (cached != null) {
        log("📦 رجعنا الكاش - getAhadith");
        return Right(cached);
      }

      // 2) لو الكاش فاضي → نجيب من API
      final response = await _apiService.getChapterAhadiths(
        bookSlug,
        chapterId,
      );

      // 3) خزنه في الكاش
      await _hadithCache.saveData(response);

      return Right(response);
    } catch (e) {
      log(e.toString());
      return Left(ErrorHandler.handle(e));
    }
  }

  /// 📦 Get Local Ahadith (with caching)
  Future<Either<ErrorHandler, LocalHadithResponse>> getLocalAhadith({
    required  bookSlug,
    required  chapterId,
  }) async {
    try {
      final cached = await _localHadithCache.getData();
      if (cached != null) {
        log("📦 رجعنا الكاش - getLocalAhadith");
        return Right(cached);
      }

      final response = await _apiService.getLocalChapterAhadiths(
        bookSlug,
        chapterId,
      );

      await _localHadithCache.saveData(response);

      return Right(response);
    } catch (e) {
      log(e.toString());
      return Left(ErrorHandler.handle(e));
    }
  }

  /// 📦 Get Three Books Local Ahadith (with caching)
  Future<Either<ErrorHandler, LocalHadithResponse>> getThreeBooksLocalAhadith({
    required  bookSlug,
    required  chapterId,
  }) async {
    try {
      final cached = await _threeBooksCache.getData();
      if (cached != null) {
        log("📦 رجعنا الكاش - getThreeBooksLocalAhadith");
        return Right(cached);
      }

      final response = await _apiService.getThreeBooksLocalChapterAhadiths(
        bookSlug,
        chapterId,
      );

      await _threeBooksCache.saveData(response);

      return Right(response);
    } catch (e) {
      log(e.toString());
      return Left(ErrorHandler.handle(e));
    }
  }
}

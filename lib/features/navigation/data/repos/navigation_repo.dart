import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:mishkat_almasabih/features/navigation/data/models/local_hadith_navigation_model.dart';
import 'package:mishkat_almasabih/features/navigation/data/models/navigation_hadith_model.dart';

class NavigationRepo {
  final ApiService _apiService;

  NavigationRepo(this._apiService);
  final _navigationHadithCache = GenericCache<NavigationHadithResponse>(
    cacheKey: "NavigationResponse",
    fromJson: (json) => NavigationHadithResponse.fromJson(json),
  );
  Future<Either<ErrorHandler, NavigationHadithResponse>> navigationHadith(
    String hadithNumber,
    String bookSlug,
    String chapterNumber,
  ) async {
    try {
      final cache = await _navigationHadithCache.getData();

      if (cache != null) {
        return Right(cache);
      }
      final response = await _apiService.navigationHadith(
        hadithNumber,
        bookSlug,
        chapterNumber,
      );
      await _navigationHadithCache.saveData(response);
      return Right(response);
    } catch (err) {
      log(err.toString());
      return Left(ErrorHandler.handle(err));
    }
  }

  Future<Either<ErrorHandler, LocalNavigationHadithResponse>> localNavigation(
    String hadithNumber,
    String bookSlug,
  ) async {
    try {
      final response = await _apiService.localNavigationHadith(
        hadithNumber,
        bookSlug,
      );
      return Right(response);
    } catch (err) {
      log(err.toString());
      return Left(ErrorHandler.handle(err));
    }
  }
}

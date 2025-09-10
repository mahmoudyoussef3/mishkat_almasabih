import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/chapters/data/models/chapters_model.dart';

class BookChaptersRepo {
  final ApiService _apiService;
  BookChaptersRepo(this._apiService);

  final _chaptersCache = GenericCache<ChaptersModel>(
    cacheKey: "chapters",
    fromJson: (json) => ChaptersModel.fromJson(json),
  );

  Future<Either<ErrorHandler, ChaptersModel>> getBookChapters(
    String bookSlug,
  ) async {
    try {
      final cache = await _chaptersCache.getData();
      if (cache != null) {
        return Right(cache);
      }
      final response = await _apiService.getBookChapters(bookSlug);
      await _chaptersCache.saveData(response);
      return Right(response);
    } catch (error) {
      log(error.toString());
      return Left(ErrorHandler.handle(error));
    }
  }
}

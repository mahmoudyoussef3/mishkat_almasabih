import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/features/ahadith/data/models/ahadiths_model.dart';
import 'package:mishkat_almasabih/features/ahadith/data/models/local_books_model.dart';

class AhadithsRepo {
  AhadithsRepo(this._apiService);
  final ApiService _apiService;
  Future<Either<ErrorHandler, HadithResponse>> getAhadith({
    required bookSlug,
    required chapterId,
  }) async {
    try {
      final response = await _apiService.getChapterAhadiths(
        bookSlug,
        chapterId,
      );

      return Right(response);
    } catch (e) {
      log(e.toString());
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<ErrorHandler, LocalHadithResponse>> getLocalAhadith({
    required bookSlug,
    required chapterId,
  }) async {
    try {
      final response = await _apiService.getLocalChapterAhadiths(
        bookSlug,
        chapterId,
      );

      return Right(response);
    } catch (e) {
      log(e.toString());
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<Either<ErrorHandler, LocalHadithResponse>> getThreeBooksLocalAhadith({
    required bookSlug,
    required chapterId,
  }) async {
    try {
      final response = await _apiService.getThreeBooksLocalChapterAhadiths(
        bookSlug,
        chapterId,
      );

      return Right(response);
    } catch (e) {
      log(e.toString());
      return Left(ErrorHandler.handle(e));
    }
  }
}

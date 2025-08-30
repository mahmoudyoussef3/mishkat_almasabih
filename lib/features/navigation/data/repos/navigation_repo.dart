import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_error_model.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/features/navigation/data/models/navigation_hadith_model.dart';

class NavigationRepo {
  final ApiService _apiService;

  NavigationRepo(this._apiService);

  Future<Either<ErrorHandler, NavigationHadithResponse>> navigationHadith(
    String hadithNumber,
    String bookSlug,
    String chapterNumber,
  ) async {
    try {
      final response = await _apiService.navigationHadith(
        /*
        hadithNumber,
        bookSlug,
        chapterNumber,
        */
      );
      return Right(response);
    } catch (err) {
      log(err.toString());
      return Left(ErrorHandler.handle(err));
    }
  }
}

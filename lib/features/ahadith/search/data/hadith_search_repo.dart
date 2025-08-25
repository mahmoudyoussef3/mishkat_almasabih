import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/features/search/home_screen/data/models/public_search_model.dart';

class HadithSearchRepo {
  final ApiService _apiService;
  HadithSearchRepo(this._apiService);

  Future<Either<ErrorHandler, SearchResponse>> getHadithSearchRepo(
    String query,
    String bookSlug,
    String chapterName,
  ) async {
    try {
      final response = await _apiService.getHadithSearch(
        query,
        bookSlug,
        chapterName,
      );

      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}

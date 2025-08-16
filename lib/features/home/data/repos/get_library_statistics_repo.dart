import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/features/home/data/models/book_model.dart';
import 'package:mishkat_almasabih/features/home/data/models/library_statistics_model.dart';

class GetLibraryStatisticsRepo {
  final ApiService _apiService;

  GetLibraryStatisticsRepo(this._apiService);

  Future<Either<ErrorHandler, StatisticsResponse>>
  getLibraryStatistics() async {
    try {
      final response = await _apiService.getLibraryStatisctics();
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}

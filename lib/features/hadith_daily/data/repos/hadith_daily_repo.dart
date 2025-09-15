import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';

class HadithDailyRepo {
  final ApiService _apiService;
  HadithDailyRepo(this._apiService);

  Future<Either<ErrorHandler, DailyHadithModel>> getDailyHadith() async {
    try {
      final response = await _apiService.getDailyHadith();

      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}

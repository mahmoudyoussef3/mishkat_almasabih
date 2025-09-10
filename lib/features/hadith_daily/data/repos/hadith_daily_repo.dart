import 'package:dartz/dartz.dart';
import 'package:easy_notify/easy_notify.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';

class HadithDailyRepo {
  final ApiService _apiService;
  HadithDailyRepo(this._apiService);

  final _dailyHadithCache = GenericCache<DailyHadithModel>(
    cacheKey: "hadith_daily",
    fromJson: (json) => DailyHadithModel.fromJson(json),
  );

  Future<Either<ErrorHandler, DailyHadithModel>> getDailyHadith() async {
    try {
      final cache = await _dailyHadithCache.getData();
      if (cache != null) {
        return Right(cache);
      }
      final response = await _apiService.getDailyHadith();

      EasyNotify.showBasicNotification(
        body: response.data?.hadith ?? '...',
        id: 0,
        title: 'حديث اليوم',
      );
      await _dailyHadithCache.saveData(response);
      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}

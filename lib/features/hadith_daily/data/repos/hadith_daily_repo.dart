import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_notify/easy_notify.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';

class HadithDailyRepo {
  final ApiService _apiService;
  HadithDailyRepo(this._apiService);


  Future<Either<ErrorHandler, DailyHadithModel>> getDailyHadith() async {
    try {
         final cacheKey = CacheKeys.hadithDaily;

      final cachedData = await GenericCacheService.instance
          .getData<DailyHadithModel>(
            key: cacheKey,
            fromJson: (json) => DailyHadithModel.fromJson(json),
          );

      if (cachedData != null) {
        log('📂 Loaded Ahadith from cache for $id ');
        return Right(cachedData);
      }

      final response = await _apiService.getDailyHadith();

      EasyNotify.showBasicNotification(
        body: response.data?.hadith ?? '...',
        id: 0,
        title: 'حديث اليوم',
      );
      
      await GenericCacheService.instance.saveData<DailyHadithModel>(
        key: cacheKey,
        data: response,
        toJson: (data) => data.toJson(),
        cacheExpirationHours: 100,
      );
      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
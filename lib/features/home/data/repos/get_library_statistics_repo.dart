import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:mishkat_almasabih/features/home/data/models/library_statistics_model.dart';

class GetLibraryStatisticsRepo {
  final ApiService _apiService;

  GetLibraryStatisticsRepo(this._apiService);
  final _statisticsResponseCache = GenericCache<StatisticsResponse>(
    cacheKey: "statistics_response",
    fromJson: (json) => StatisticsResponse.fromJson(json),
  );
  Future<Either<ErrorHandler, StatisticsResponse>>
  getLibraryStatistics() async {
    try {
      final cache = await _statisticsResponseCache.getData();
      if (cache != null) {
                log("cache library statistics is $cache");

        return Right(cache);
      }
      final response = await _apiService.getLibraryStatisctics();
      await _statisticsResponseCache.saveData(response);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}

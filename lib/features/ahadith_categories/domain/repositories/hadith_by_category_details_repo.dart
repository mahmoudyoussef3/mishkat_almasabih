import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/new_daily_hadith_model.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';

class HadithByCategoryDetailsRepo {
  final _cacheService = GenericCacheService.instance;

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://hadeethenc.com/api/v1/",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  )..interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );

  static Dio get dio => _dio;

  /// Get cached hadith
  Future<NewDailyHadithModel?> getCachedHadith(String id) async {
    final cacheKey = CacheKeys.hadithDetails(id);
    return await _cacheService.getData<NewDailyHadithModel>(
      key: cacheKey,
      fromJson: NewDailyHadithModel.fromJson,
    );
  }

  /// Save hadith to cache
  Future<void> cacheHadith(String id, NewDailyHadithModel data) async {
    final cacheKey = CacheKeys.hadithDetails(id);
    await _cacheService.saveData<NewDailyHadithModel>(
      key: cacheKey,
      data: data,
      toJson: (d) => d.toJson(),
      cacheExpirationHours: 24, // Cache details for 24 hours
    );
  }

  Future<NewDailyHadithModel?> fetchHadith(String id) async {
    try {
      final response = await _dio.get("hadeeths/one/", queryParameters: {
        "language": "ar",
        "id": id,
      });

      final hadithModel = NewDailyHadithModel.fromJson(response.data);

      // Cache the response
      await cacheHadith(id, hadithModel);

      return hadithModel;
    } catch (e) {
      debugPrint("❌ Error fetching hadith: $e");
      return null;
    }
  }
}

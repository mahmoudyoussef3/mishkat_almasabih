import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:mishkat_almasabih/features/hadith_analysis/data/models/hadith_analysis_request.dart';
import 'package:mishkat_almasabih/features/hadith_analysis/data/models/hadith_analysis_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HadithAnalysisRepo {
  final ApiService apiService;
  HadithAnalysisRepo(this.apiService);

  final _hadithAnalysisCache = GenericCache<HadithAnalysisResponse>(
    cacheKey: "hadith_analysis",
    fromJson: (json) => HadithAnalysisResponse.fromJson(json),
  );

  Future<Either<ErrorHandler, HadithAnalysisResponse>> analyzeHadith(
    HadithAnalysisRequest request,
  ) async {
    try {
      final cache = await _hadithAnalysisCache.getData();
      if (cache != null) {
        return Right(cache);
      }
      final String token = await _getUserToken();
      final response = await apiService.hadithAnalysis(request, token);
      await _hadithAnalysisCache.saveData(response);
      return Right(response);
    } catch (e) {
      log(e.toString());
      return Left(ErrorHandler.handle(e));
    }
  }

  Future<String> _getUserToken() async {
    final sharedPref = await SharedPreferences.getInstance();
    final token = sharedPref.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception("No token found, user not logged in");
    }
    return token;
  }
}

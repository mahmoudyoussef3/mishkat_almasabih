import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class SaveHadithDailyRepo {
  static const String _key = "dailyHadith";

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
  /// حفظ الحديث في SharedPreferences
  Future<void> saveHadith(HadithData model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());

    await prefs.setString(_key, jsonString);
    debugPrint("💾 Hadith saved");
  }

  /// جلب الحديث المخزن
  Future<HadithData?> getHadith() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return HadithData.fromJson(jsonMap);
  }

  /// حذف الحديث
  Future<void> deleteHadith() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    debugPrint('🗑️ Hadith deleted');
  }

  /// جلب حديث جديد من API وحفظه فوراً
  Future<HadithData?> fetchHadith(String id) async {
    try {
      final response =
          await _dio.get("hadeeths/one/", queryParameters: {
        "language": "ar",
        "id": id,
      });

      final hadithModel = HadithData.fromJson(response.data);

      await saveHadith(hadithModel);
      debugPrint('✅ New hadith fetched and saved');

      return hadithModel;
    } catch (e) {
      debugPrint("❌ Error fetching hadith: $e");
      return null;
    }
  }
}

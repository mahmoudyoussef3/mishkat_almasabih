import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveHadithDailyRepo {
  static const String _key = "dailyHadith";
  static const String _dateKey = "dailyHadithDate";
  final ApiService apiService;

  SaveHadithDailyRepo(this.apiService);

  Future<void> saveHadith(DailyHadithModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());

    // احفظ التاريخ والوقت للمقارنة بالساعة
    final now = DateTime.now();
    // احفظ حتى مستوى الساعة فقط (بدون الدقائق والثواني)
    final currentHour = DateTime(now.year, now.month, now.day, now.hour);

    await prefs.setString(_key, jsonString);
    await prefs.setString(_dateKey, currentHour.toIso8601String());

    debugPrint('💾 Hadith saved for ${currentHour.toIso8601String()}');
  }

  Future<bool> isSameHour() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDateStr = prefs.getString(_dateKey);
    if (savedDateStr == null) return false;

    final savedDate = DateTime.parse(savedDateStr);
    final now = DateTime.now();
    
    // احصل على الساعة الحالية (بدون دقائق وثواني)
    final currentHour = DateTime(now.year, now.month, now.day, now.hour);

    // قارن مع الساعة المحفوظة
    return savedDate == currentHour;
  }

  Future<void> deleteHadith() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_dateKey);
    debugPrint('🗑️ Hadith deleted');
  }

  Future<DailyHadithModel?> getHadith() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return DailyHadithModel.fromJson(jsonMap);
  }

  Future<bool> isSameDay() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDateStr = prefs.getString(_dateKey);
    if (savedDateStr == null) return false;

    final savedDate = DateTime.parse(savedDateStr);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final savedDay = DateTime(savedDate.year, savedDate.month, savedDate.day);

    return savedDay == today;
  }

  Future<DailyHadithModel?> getHadithForToday() async {
    final isValid = await isSameHour();
    if (isValid) {
      return await getHadith();
    } else {
      await deleteHadith();
      return null;
    }
  }

  /// جلب حديث جديد كل ساعة
  Future<DailyHadithModel> fetchHadith() async {
    DailyHadithModel? hadith = await getHadithForToday();

    if (hadith == null) {
      // مش لاقي حديث أو ساعة جديدة → هات من API
      debugPrint('🔄 Fetching new hadith from API...');
      final newHadith = await apiService.getDailyHadith();
      await saveHadith(newHadith);
      hadith = newHadith;
      debugPrint('✅ New hadith fetched and saved');
    } else {
      debugPrint('📖 Using cached hadith for current hour');
    }

    return hadith;
  }

  /// دالة مساعدة لمعرفة كم باقي على الساعة الجديدة
  int getMinutesUntilNextHour() {
    final now = DateTime.now();
    return 60 - now.minute;
  }

  /// دالة لحذف الحديث يدوياً (لأغراض التطوير)
  Future<void> forceRefresh() async {
    await deleteHadith();
    debugPrint('🔄 Forced refresh - hadith cache cleared');
  }
}
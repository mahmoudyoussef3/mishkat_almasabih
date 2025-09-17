import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveHadithDailyRepo {
  static const String _key = "dailyHadith";
  static const String _timestampKey = "dailyHadithTimestamp";

  Future<void> saveHadith(DailyHadithModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());
    
    // حفظ الحديث مع وقت الحفظ
    await prefs.setString(_key, jsonString);
    await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    
    debugPrint('💾 Hadith saved with timestamp');
  }

  Future<void> deleteHadith() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_timestampKey);
    debugPrint('🗑️ Hadith deleted');
  }

  Future<DailyHadithModel?> getHadith() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return DailyHadithModel.fromJson(jsonMap);
  }

  // الحصول على وقت آخر تحديث
  Future<DateTime?> getLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_timestampKey);
    if (timestamp == null) return null;
    
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Future<bool> isHadithExpired() async {
    final lastUpdate = await getLastUpdateTime();
    if (lastUpdate == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastUpdate).inSeconds;
    
    return difference >= 60; 
  }
}
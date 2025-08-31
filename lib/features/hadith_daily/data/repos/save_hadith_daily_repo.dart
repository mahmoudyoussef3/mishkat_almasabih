import 'dart:convert';

import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveHadithDailyRepo {
  Future<void> saveHadith(DailyHadithModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());
    await prefs.setString("dailyHadith", jsonString);
  }

    Future<void> deleteHadith() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("dailyHadith");
  }

  Future<DailyHadithModel?> getHadith() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("dailyHadith");
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return DailyHadithModel.fromJson(jsonMap);
  }
}

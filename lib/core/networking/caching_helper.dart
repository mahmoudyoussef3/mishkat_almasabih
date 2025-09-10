import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class GenericCache<T> {
  final String cacheKey;
  final FromJson<T> fromJson;

  GenericCache({required this.cacheKey, required this.fromJson});

  /// حفظ الموديل في الكاش
  Future<void> saveData(T data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cacheKey, jsonEncode(data));
  }

  /// جلب الداتا من الكاش
  Future<T?> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(cacheKey);
    if (jsonString != null) {
      return fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  /// مسح الكاش
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cacheKey);
  }
}

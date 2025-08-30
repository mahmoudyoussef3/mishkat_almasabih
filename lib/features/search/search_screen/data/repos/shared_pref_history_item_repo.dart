import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPrefs {
  static const String _key = "history_items";

  // Save list
  static Future<void> saveHistory(List<HistoryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded =
        items.map((item) => jsonEncode(item.toMap())).toList();
    await prefs.setStringList(_key, encoded);
  }

static Future<Either<dynamic, List<HistoryItem>>> loadHistory() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(_key);

    if (encoded == null) {
      return const Right([]); 
    }

    final history = encoded
        .map((item) => HistoryItem.fromMap(jsonDecode(item)))
        .toList();

    return Right(history); 
  } catch (e) {
    return Left(e); 
  }
}


  // Clear all
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

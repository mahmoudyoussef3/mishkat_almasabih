import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPrefs {
  static const String filteredSearch = "filteredSearch";
    static const String enhancedPublicSearch = "enhancedPublicSearch";


  // Save lista
  static Future<void> saveHistory(List<HistoryItem> items,String searchCategory) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded =
        items.map((item) => jsonEncode(item.toMap())).toList();
    await prefs.setStringList(searchCategory, encoded);
  }

static Future<Either<dynamic, List<HistoryItem>>> loadHistory(String searchCategor) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encoded = prefs.getStringList(searchCategor);

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


  
  static Future<void> clearHistory(String searchCategory) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(searchCategory);
  }
}

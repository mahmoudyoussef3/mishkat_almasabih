import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mishkat_almasabih/features/home/data/models/library_statistics_model.dart';
import 'package:mishkat_almasabih/features/home/data/models/book_model.dart';

class CacheService {
  static const String _statisticsKey = 'library_statistics_cache';
  static const String _booksKey = 'books_with_categories_cache';
  static const String _statisticsTimestampKey = 'statistics_timestamp';
  static const String _booksTimestampKey = 'books_timestamp';
  
  // Cache duration in hours
  static const int _cacheExpirationHours = 24;
  
  static CacheService? _instance;
  static CacheService get instance => _instance ??= CacheService._();
  CacheService._();

  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // =========================== STATISTICS CACHING ===========================

  /// Save library statistics to cache
  Future<bool> saveStatistics(StatisticsResponse statistics) async {
    try {
      await init();
      
      final jsonString = jsonEncode(statistics.toJson());
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      final statsResult = await _prefs!.setString(_statisticsKey, jsonString);
      final timestampResult = await _prefs!.setInt(_statisticsTimestampKey, timestamp);
      
      log('✅ Statistics cached successfully: $statsResult && $timestampResult');
      return statsResult && timestampResult;
    } catch (e) {
      log('❌ Error caching statistics: $e');
      return false;
    }
  }

  /// Get library statistics from cache
  Future<StatisticsResponse?> getStatistics() async {
    try {
      await init();
      
      // Check if cache exists and is not expired
      if (!await _isStatisticsCacheValid()) {
        log('📅 Statistics cache expired or invalid');
        return null;
      }
      
      final jsonString = _prefs!.getString(_statisticsKey);
      if (jsonString == null) {
        log('❌ No cached statistics found');
        return null;
      }
      
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final statistics = StatisticsResponse.fromJson(jsonMap);
      
      log('✅ Statistics loaded from cache');
      return statistics;
    } catch (e) {
      log('❌ Error loading cached statistics: $e');
      await clearStatisticsCache(); // Clear corrupted cache
      return null;
    }
  }

  /// Check if statistics cache is valid (not expired)
  Future<bool> _isStatisticsCacheValid() async {
    await init();
    
    final timestamp = _prefs!.getInt(_statisticsTimestampKey);
    if (timestamp == null) return false;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cacheTime);
    
    return difference.inHours < _cacheExpirationHours;
  }

  /// Clear statistics cache
  Future<bool> clearStatisticsCache() async {
    try {
      await init();
      
      final result1 = await _prefs!.remove(_statisticsKey);
      final result2 = await _prefs!.remove(_statisticsTimestampKey);
      
      log('🗑️ Statistics cache cleared: $result1 && $result2');
      return result1 && result2;
    } catch (e) {
      log('❌ Error clearing statistics cache: $e');
      return false;
    }
  }

  // =========================== BOOKS CACHING ===========================

  /// Save books with categories to cache
  Future<bool> saveBooks(BooksResponse books) async {
    try {
      await init();
      
      final jsonString = jsonEncode(books.toJson());
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      final booksResult = await _prefs!.setString(_booksKey, jsonString);
      final timestampResult = await _prefs!.setInt(_booksTimestampKey, timestamp);
      
      log('✅ Books cached successfully: $booksResult && $timestampResult');
      return booksResult && timestampResult;
    } catch (e) {
      log('❌ Error caching books: $e');
      return false;
    }
  }

  /// Get books with categories from cache
  Future<BooksResponse?> getBooks() async {
    try {
      await init();
      
      // Check if cache exists and is not expired
      if (!await _isBooksCacheValid()) {
        log('📅 Books cache expired or invalid');
        return null;
      }
      
      final jsonString = _prefs!.getString(_booksKey);
      if (jsonString == null) {
        log('❌ No cached books found');
        return null;
      }
      
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final books = BooksResponse.fromJson(jsonMap);
      
      log('✅ Books loaded from cache');
      return books;
    } catch (e) {
      log('❌ Error loading cached books: $e');
      await clearBooksCache(); // Clear corrupted cache
      return null;
    }
  }

  /// Check if books cache is valid (not expired)
  Future<bool> _isBooksCacheValid() async {
    await init();
    
    final timestamp = _prefs!.getInt(_booksTimestampKey);
    if (timestamp == null) return false;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cacheTime);
    
    return difference.inHours < _cacheExpirationHours;
  }

  /// Clear books cache
  Future<bool> clearBooksCache() async {
    try {
      await init();
      
      final result1 = await _prefs!.remove(_booksKey);
      final result2 = await _prefs!.remove(_booksTimestampKey);
      
      log('🗑️ Books cache cleared: $result1 && $result2');
      return result1 && result2;
    } catch (e) {
      log('❌ Error clearing books cache: $e');
      return false;
    }
  }

  // =========================== GENERAL CACHE METHODS ===========================

  /// Clear all cache
  Future<bool> clearAllCache() async {
    try {
      final result1 = await clearStatisticsCache();
      final result2 = await clearBooksCache();
      
      log('🗑️ All cache cleared: $result1 && $result2');
      return result1 && result2;
    } catch (e) {
      log('❌ Error clearing all cache: $e');
      return false;
    }
  }

  /// Check if any cache exists
  Future<bool> hasCachedData() async {
    await init();
    
    final hasStats = _prefs!.containsKey(_statisticsKey);
    final hasBooks = _prefs!.containsKey(_booksKey);
    
    return hasStats || hasBooks;
  }

  /// Get cache info for debugging
  Future<Map<String, dynamic>> getCacheInfo() async {
    await init();
    
    final statsTimestamp = _prefs!.getInt(_statisticsTimestampKey);
    final booksTimestamp = _prefs!.getInt(_booksTimestampKey);
    
    return {
      'statistics': {
        'exists': _prefs!.containsKey(_statisticsKey),
        'valid': await _isStatisticsCacheValid(),
        'timestamp': statsTimestamp != null 
          ? DateTime.fromMillisecondsSinceEpoch(statsTimestamp).toString()
          : null,
      },
      'books': {
        'exists': _prefs!.containsKey(_booksKey),
        'valid': await _isBooksCacheValid(),
        'timestamp': booksTimestamp != null 
          ? DateTime.fromMillisecondsSinceEpoch(booksTimestamp).toString()
          : null,
      },
    };
  }

  /// Force refresh cache (clear and fetch new data)
  Future<bool> forceRefresh() async {
    final result = await clearAllCache();
    log('🔄 Force refresh - cache cleared: $result');
    return result;
  }
}
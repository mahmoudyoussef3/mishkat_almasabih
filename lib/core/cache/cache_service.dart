import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

/// Professional caching service for Mishkat Al-Masabih app
/// Provides comprehensive caching functionality for all API responses
class CacheService {
  static const String _cachePrefix = 'mishkat_cache_';
  static const String _timestampPrefix = 'mishkat_timestamp_';
  static const String _versionPrefix = 'mishkat_version_';

  // Cache duration constants (in minutes)
  static const int _defaultCacheDuration = 30; // 30 minutes
  static const int _booksCacheDuration = 60; // 1 hour for books data
  static const int _statisticsCacheDuration = 120; // 2 hours for statistics
  static const int _userDataCacheDuration = 15; // 15 minutes for user data
  static const int _searchCacheDuration = 10; // 10 minutes for search results

  static SharedPreferences? _prefs;

  /// Initialize the cache service
  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    log('CacheService initialized successfully');
  }

  /// Get cached data with automatic expiration check
  static Future<T?> getCachedData<T>(
    String key, {
    int? customCacheDuration,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      await _ensureInitialized();

      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_timestampPrefix$key';

      final cachedData = _prefs!.getString(cacheKey);
      final timestamp = _prefs!.getInt(timestampKey);

      if (cachedData == null || timestamp == null) {
        log('No cached data found for key: $key');
        return null;
      }

      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final cacheDuration =
          customCacheDuration ?? _getDefaultCacheDuration(key);
      final maxAge = cacheDuration * 60 * 1000; // Convert to milliseconds

      if (cacheAge > maxAge) {
        log(
          'Cache expired for key: $key (age: ${cacheAge / 1000 / 60} minutes)',
        );
        await _removeCachedData(key);
        return null;
      }

      final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
      final result = fromJson(jsonData);

      log(
        'Cache hit for key: $key (age: ${(cacheAge / 1000 / 60).toStringAsFixed(1)} minutes)',
      );
      return result;
    } catch (e) {
      log('Error getting cached data for key $key: $e');
      return null;
    }
  }

  /// Cache data with automatic timestamp
  static Future<void> cacheData<T>(
    String key,
    T data, {
    int? customCacheDuration,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    try {
      await _ensureInitialized();

      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_timestampPrefix$key';
      final versionKey = '$_versionPrefix$key';

      final jsonData = toJson(data);
      final jsonString = jsonEncode(jsonData);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final version =
          DateTime.now().millisecondsSinceEpoch; // For cache invalidation

      await _prefs!.setString(cacheKey, jsonString);
      await _prefs!.setInt(timestampKey, timestamp);
      await _prefs!.setInt(versionKey, version);

      log('Data cached successfully for key: $key');
    } catch (e) {
      log('Error caching data for key $key: $e');
    }
  }

  /// Check if cached data exists and is valid
  static Future<bool> hasValidCache(
    String key, {
    int? customCacheDuration,
  }) async {
    try {
      await _ensureInitialized();

      final timestampKey = '$_timestampPrefix$key';
      final timestamp = _prefs!.getInt(timestampKey);

      if (timestamp == null) return false;

      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final cacheDuration =
          customCacheDuration ?? _getDefaultCacheDuration(key);
      final maxAge = cacheDuration * 60 * 1000;

      return cacheAge <= maxAge;
    } catch (e) {
      log('Error checking cache validity for key $key: $e');
      return false;
    }
  }

  /// Remove specific cached data
  static Future<void> _removeCachedData(String key) async {
    try {
      await _ensureInitialized();

      final cacheKey = '$_cachePrefix$key';
      final timestampKey = '$_timestampPrefix$key';
      final versionKey = '$_versionPrefix$key';

      await _prefs!.remove(cacheKey);
      await _prefs!.remove(timestampKey);
      await _prefs!.remove(versionKey);

      log('Cached data removed for key: $key');
    } catch (e) {
      log('Error removing cached data for key $key: $e');
    }
  }

  /// Clear all cached data
  static Future<void> clearAllCache() async {
    try {
      await _ensureInitialized();

      final keys = _prefs!.getKeys();
      final cacheKeys =
          keys
              .where(
                (key) =>
                    key.startsWith(_cachePrefix) ||
                    key.startsWith(_timestampPrefix) ||
                    key.startsWith(_versionPrefix),
              )
              .toList();

      for (final key in cacheKeys) {
        await _prefs!.remove(key);
      }

      log('All cache cleared successfully');
    } catch (e) {
      log('Error clearing all cache: $e');
    }
  }

  /// Clear cache for specific pattern
  static Future<void> clearCachePattern(String pattern) async {
    try {
      await _ensureInitialized();

      final keys = _prefs!.getKeys();
      final cacheKeys =
          keys
              .where(
                (key) =>
                    (key.startsWith(_cachePrefix) ||
                        key.startsWith(_timestampPrefix) ||
                        key.startsWith(_versionPrefix)) &&
                    key.contains(pattern),
              )
              .toList();

      for (final key in cacheKeys) {
        await _prefs!.remove(key);
      }

      log('Cache cleared for pattern: $pattern');
    } catch (e) {
      log('Error clearing cache pattern $pattern: $e');
    }
  }

  /// Get cache statistics
  static Future<Map<String, dynamic>> getCacheStats() async {
    try {
      await _ensureInitialized();

      final keys = _prefs!.getKeys();
      final cacheKeys =
          keys.where((key) => key.startsWith(_cachePrefix)).toList();

      int totalItems = cacheKeys.length;
      int expiredItems = 0;
      int validItems = 0;

      for (final key in cacheKeys) {
        final cleanKey = key.replaceFirst(_cachePrefix, '');
        if (await hasValidCache(cleanKey)) {
          validItems++;
        } else {
          expiredItems++;
        }
      }

      return {
        'totalItems': totalItems,
        'validItems': validItems,
        'expiredItems': expiredItems,
        'cacheHitRate':
            totalItems > 0
                ? (validItems / totalItems * 100).toStringAsFixed(1)
                : '0.0',
      };
    } catch (e) {
      log('Error getting cache stats: $e');
      return {
        'totalItems': 0,
        'validItems': 0,
        'expiredItems': 0,
        'cacheHitRate': '0.0',
      };
    }
  }

  /// Ensure cache service is initialized
  static Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await initialize();
    }
  }

  /// Get default cache duration based on data type
  static int _getDefaultCacheDuration(String key) {
    if (key.contains('books') || key.contains('categories')) {
      return _booksCacheDuration;
    } else if (key.contains('statistics')) {
      return _statisticsCacheDuration;
    } else if (key.contains('user') || key.contains('profile')) {
      return _userDataCacheDuration;
    } else if (key.contains('search')) {
      return _searchCacheDuration;
    } else {
      return _defaultCacheDuration;
    }
  }

  /// Generate cache key with parameters
  static String generateCacheKey(
    String baseKey,
    Map<String, dynamic>? parameters,
  ) {
    if (parameters == null || parameters.isEmpty) {
      return baseKey;
    }

    final sortedParams = Map.fromEntries(
      parameters.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    final paramString = sortedParams.entries
        .map((e) => '${e.key}:${e.value}')
        .join('_');

    return '${baseKey}_$paramString';
  }
}

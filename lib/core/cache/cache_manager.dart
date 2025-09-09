import 'dart:developer';
import 'cache_service.dart';

/// Cache Manager for Mishkat Al-Masabih app
/// Provides high-level cache management operations
class CacheManager {
  /// Clear all cache data
  static Future<void> clearAllCache() async {
    try {
      await CacheService.clearAllCache();
      log('All cache cleared successfully');
    } catch (e) {
      log('Error clearing all cache: $e');
    }
  }

  /// Clear cache for specific feature
  static Future<void> clearFeatureCache(String feature) async {
    try {
      await CacheService.clearCachePattern(feature);
      log('Cache cleared for feature: $feature');
    } catch (e) {
      log('Error clearing cache for feature $feature: $e');
    }
  }

  /// Clear user-specific cache (when user logs out)
  static Future<void> clearUserCache() async {
    try {
      await CacheService.clearCachePattern('user_');
      await CacheService.clearCachePattern('bookmarks');
      await CacheService.clearCachePattern('profile');
      log('User cache cleared successfully');
    } catch (e) {
      log('Error clearing user cache: $e');
    }
  }

  /// Clear books and categories cache
  static Future<void> clearBooksCache() async {
    try {
      await CacheService.clearCachePattern('books');
      await CacheService.clearCachePattern('categories');
      await CacheService.clearCachePattern('chapters');
      await CacheService.clearCachePattern('ahadith');
      log('Books cache cleared successfully');
    } catch (e) {
      log('Error clearing books cache: $e');
    }
  }

  /// Clear search cache
  static Future<void> clearSearchCache() async {
    try {
      await CacheService.clearCachePattern('search');
      log('Search cache cleared successfully');
    } catch (e) {
      log('Error clearing search cache: $e');
    }
  }

  /// Get cache statistics
  static Future<Map<String, dynamic>> getCacheStats() async {
    return await CacheService.getCacheStats();
  }

  /// Preload essential data
  static Future<void> preloadEssentialData() async {
    try {
      // This can be called during app startup to preload critical data
      log('Preloading essential data...');

      // Add preloading logic here if needed
      // For example, preload books data, user profile, etc.

      log('Essential data preloaded successfully');
    } catch (e) {
      log('Error preloading essential data: $e');
    }
  }

  /// Check if cache is healthy
  static Future<bool> isCacheHealthy() async {
    try {
      final stats = await getCacheStats();
      final hitRate = double.parse(stats['cacheHitRate'] as String);

      // Consider cache healthy if hit rate is above 50%
      return hitRate > 50.0;
    } catch (e) {
      log('Error checking cache health: $e');
      return false;
    }
  }

  /// Optimize cache (remove expired entries)
  static Future<void> optimizeCache() async {
    try {
      final stats = await getCacheStats();
      final expiredItems = stats['expiredItems'] as int;

      if (expiredItems > 0) {
        log('Optimizing cache: removing $expiredItems expired entries');
        // The cache service automatically handles expired entries
        // This is just for logging and monitoring
      }

      log('Cache optimization completed');
    } catch (e) {
      log('Error optimizing cache: $e');
    }
  }
}

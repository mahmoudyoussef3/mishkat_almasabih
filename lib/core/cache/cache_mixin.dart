import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cache_service.dart';

/// Mixin to provide caching functionality to cubits
/// Simplifies the implementation of cache-first data loading
mixin CacheMixin<T, S> on Cubit<S> {
  /// Load data with cache-first strategy
  /// Returns true if data was loaded from cache, false if from API
  Future<bool> loadWithCache<TData>({
    required String cacheKey,
    required Future<TData> Function() apiCall,
    required TData Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(TData) toJson,
    required void Function(TData) onSuccess,
    required void Function(String) onError,
    required S Function() loadingState,
    int? customCacheDuration,
  }) async {
    try {
      // Emit loading state
      emit(loadingState);

      // Try to get cached data first
      final cachedData = await CacheService.getCachedData<TData>(
        cacheKey,
        customCacheDuration: customCacheDuration,
        fromJson: fromJson,
      );

      if (cachedData != null) {
        log('Loading from cache: $cacheKey');
        onSuccess(cachedData);
        return true; // Data loaded from cache
      }

      // No valid cache, fetch from API
      log('Loading from API: $cacheKey');
      final apiData = await apiCall();

      // Cache the API response
      await CacheService.cacheData<TData>(
        cacheKey,
        apiData,
        customCacheDuration: customCacheDuration,
        toJson: toJson,
      );

      onSuccess(apiData);
      return false; // Data loaded from API
    } catch (e) {
      log('Error in loadWithCache for $cacheKey: $e');
      onError(e.toString());
      return false;
    }
  }

  /// Load data with cache-first strategy and refresh capability
  Future<bool> loadWithCacheAndRefresh<TData>({
    required String cacheKey,
    required Future<TData> Function() apiCall,
    required TData Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(TData) toJson,
    required void Function(TData) onSuccess,
    required void Function(String) onError,
    required S Function() loadingState,
    bool forceRefresh = false,
    int? customCacheDuration,
  }) async {
    try {
      // Emit loading state
      emit(loadingState);

      // If not forcing refresh, try cache first
      if (!forceRefresh) {
        final cachedData = await CacheService.getCachedData<TData>(
          cacheKey,
          customCacheDuration: customCacheDuration,
          fromJson: fromJson,
        );

        if (cachedData != null) {
          log('Loading from cache: $cacheKey');
          onSuccess(cachedData);

          // Fetch fresh data in background for next time
          _refreshInBackground(cacheKey, apiCall, toJson, customCacheDuration);
          return true;
        }
      }

      // Fetch from API
      log('Loading from API: $cacheKey');
      final apiData = await apiCall();

      // Cache the API response
      await CacheService.cacheData<TData>(
        cacheKey,
        apiData,
        customCacheDuration: customCacheDuration,
        toJson: toJson,
      );

      onSuccess(apiData);
      return false;
    } catch (e) {
      log('Error in loadWithCacheAndRefresh for $cacheKey: $e');
      onError(e.toString());
      return false;
    }
  }

  /// Refresh data in background without affecting UI
  Future<void> _refreshInBackground<TData>(
    String cacheKey,
    Future<TData> Function() apiCall,
    Map<String, dynamic> Function(TData) toJson,
    int? customCacheDuration,
  ) async {
    try {
      final apiData = await apiCall();
      await CacheService.cacheData<TData>(
        cacheKey,
        apiData,
        customCacheDuration: customCacheDuration,
        toJson: toJson,
      );
      log('Background refresh completed for: $cacheKey');
    } catch (e) {
      log('Background refresh failed for $cacheKey: $e');
    }
  }

  /// Clear specific cache
  Future<void> clearCache(String cacheKey) async {
    await CacheService.clearCachePattern(cacheKey);
  }

  /// Check if cache exists and is valid
  Future<bool> hasValidCache(
    String cacheKey, {
    int? customCacheDuration,
  }) async {
    return await CacheService.hasValidCache(
      cacheKey,
      customCacheDuration: customCacheDuration,
    );
  }
}

# Professional Caching System for Mishkat Al-Masabih

This directory contains a comprehensive caching system built with SharedPreferences for the Mishkat Al-Masabih Islamic library app.

## Features

- **Automatic Cache Expiration**: Data automatically expires based on configurable timeouts
- **Cache-First Strategy**: Always tries to load from cache first, then falls back to API
- **Background Refresh**: Optionally refreshes data in background while showing cached data
- **Smart Cache Keys**: Generates unique cache keys with parameters
- **Cache Statistics**: Monitor cache performance and hit rates
- **Selective Cache Clearing**: Clear cache by feature or pattern
- **Professional Error Handling**: Comprehensive error handling and logging

## Architecture

### Core Components

1. **CacheService**: Low-level caching operations
2. **CacheMixin**: High-level mixin for cubits
3. **CacheManager**: Cache management utilities
4. **Cache Example**: Usage examples and documentation

### Cache Duration Strategy

- **Books & Categories**: 60 minutes (relatively static data)
- **Statistics**: 120 minutes (rarely changes)
- **User Data**: 15 minutes (frequently updated)
- **Search Results**: 10 minutes (dynamic content)
- **Daily Hadith**: 1440 minutes (24 hours, changes daily)
- **Default**: 30 minutes

## Usage

### Basic Implementation in Cubit

```dart
class MyCubit extends Cubit<MyState> with CacheMixin {
  Future<void> loadData({bool forceRefresh = false}) async {
    const cacheKey = 'my_data';
    
    await loadWithCacheAndRefresh<MyDataModel>(
      cacheKey: cacheKey,
      apiCall: () async {
        final result = await myRepo.getData();
        return result.fold(
          (error) => throw Exception(error.message),
          (data) => data,
        );
      },
      fromJson: (json) => MyDataModel.fromJson(json),
      toJson: (data) => data.toJson(),
      onSuccess: (data) => emit(MySuccess(data)),
      onError: (error) => emit(MyError(error)),
      loadingState: () => MyLoading(),
      forceRefresh: forceRefresh,
      customCacheDuration: 60, // Optional: override default duration
    );
  }
}
```

### Cache Key Generation

```dart
// Simple key
const cacheKey = 'user_profile';

// Key with parameters
final cacheKey = CacheService.generateCacheKey('book_chapters', {
  'bookSlug': bookSlug,
  'chapterId': chapterId.toString(),
});
```

### Cache Management

```dart
// Clear all cache
await CacheManager.clearAllCache();

// Clear specific feature cache
await CacheManager.clearBooksCache();

// Clear user-specific cache (on logout)
await CacheManager.clearUserCache();

// Get cache statistics
final stats = await CacheManager.getCacheStats();
print('Cache hit rate: ${stats['cacheHitRate']}%');
```

## Implemented Cubits

The following cubits have been updated with caching:

1. **GetAllBooksWithCategoriesCubit**: Books and categories data
2. **BookDataCubit**: Individual book data by category
3. **ChaptersCubit**: Book chapters
4. **AhadithsCubit**: Hadith collections (regular, local, arbain)
5. **GetBookmarksCubit**: User bookmarks
6. **GetLibraryStatisticsCubit**: Library statistics
7. **ProfileCubit**: User profile data
8. **DailyHadithCubit**: Daily hadith (improved existing caching)

## Benefits

### Performance
- **Faster Loading**: Cached data loads instantly
- **Reduced API Calls**: Fewer network requests
- **Better UX**: No loading spinners for cached data
- **Offline Support**: App works with cached data when offline

### User Experience
- **Instant Response**: Cached data appears immediately
- **Background Updates**: Fresh data loads in background
- **Smart Refresh**: Force refresh option available
- **Error Recovery**: Graceful fallback to cached data

### Development
- **Easy Integration**: Simple mixin-based implementation
- **Consistent Pattern**: Same pattern across all cubits
- **Professional Logging**: Comprehensive logging for debugging
- **Flexible Configuration**: Customizable cache durations

## Cache Flow

1. **Check Cache**: Look for valid cached data
2. **Return Cached**: If valid cache exists, return it immediately
3. **Fetch API**: If no cache, fetch from API
4. **Cache Response**: Store API response in cache
5. **Background Refresh**: Optionally refresh in background for next time

## Error Handling

- **Cache Errors**: Gracefully fall back to API calls
- **API Errors**: Show error state to user
- **Network Issues**: Use cached data when available
- **Corrupted Cache**: Automatically clear and retry

## Monitoring

- **Cache Statistics**: Track hit rates and performance
- **Logging**: Comprehensive logging for debugging
- **Health Checks**: Monitor cache health
- **Optimization**: Automatic cleanup of expired entries

## Best Practices

1. **Use Descriptive Cache Keys**: Make keys meaningful and unique
2. **Set Appropriate Durations**: Match cache duration to data update frequency
3. **Handle Errors Gracefully**: Always provide fallback mechanisms
4. **Monitor Performance**: Use cache statistics to optimize
5. **Clear User Data**: Clear user-specific cache on logout
6. **Test Offline**: Ensure app works with cached data only

## Future Enhancements

- **Compression**: Compress large cached data
- **Encryption**: Encrypt sensitive cached data
- **Analytics**: Detailed cache performance analytics
- **Smart Preloading**: Preload data based on user behavior
- **Cache Warming**: Preload critical data on app startup

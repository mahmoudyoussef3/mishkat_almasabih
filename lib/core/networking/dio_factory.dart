import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_constants.dart';

/// Dio Factory for creating and configuring Dio instances
/// Handles interceptors, timeouts, and other network configurations
class DioFactory {
  /// Private constructor to prevent instantiation
  DioFactory._();

  /// Singleton instance of Dio
  static Dio? _dio;

  /// Get configured Dio instance
  /// Creates new instance if none exists, otherwise returns existing one
  static Future<Dio> getDio() async {
    if (_dio == null) {
      _dio = await _createDio();
    }
    return _dio!;
  }

  /// Create and configure a new Dio instance
  static Future<Dio> _createDio() async {
    final dio = Dio();

    // Configure base options
    dio.options = BaseOptions(
      baseUrl: ApiConstants.apiBaseUrl,
      connectTimeout: Duration(milliseconds: ApiConstants.connectionTimeout),
      receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
      sendTimeout: Duration(milliseconds: ApiConstants.connectionTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': 'en,ar', // Support for English and Arabic
        'User-Agent': 'MishkatAlMasabih/1.0.0',
      },
      validateStatus: (status) {
        // Consider 2xx and 3xx as success
        return status != null && status < 400;
      },
    );

    // Add interceptors
    await _addInterceptors(dio);

    return dio;
  }

  /// Add all necessary interceptors to Dio
  static Future<void> _addInterceptors(Dio dio) async {
    // Add logging interceptor (only in debug mode)
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    // Add authentication interceptor
    dio.interceptors.add(_AuthInterceptor());

    // Add retry interceptor
    dio.interceptors.add(_RetryInterceptor());

    // Add cache interceptor
    dio.interceptors.add(_CacheInterceptor());

    // Add error handling interceptor
    dio.interceptors.add(_ErrorHandlingInterceptor());
  }

  /// Clear Dio instance (useful for testing or reconfiguration)
  static void clearDio() {
    _dio = null;
  }

  /// Update base URL (useful for switching environments)
  static Future<void> updateBaseUrl(String newBaseUrl) async {
    if (_dio != null) {
      _dio!.options.baseUrl = newBaseUrl;
    }
  }

  /// Update authentication token
  static Future<void> updateAuthToken(String? token) async {
    if (_dio != null && token != null) {
      _dio!.options.headers['Authorization'] = 'Bearer $token';
    } else if (_dio != null) {
      _dio!.options.headers.remove('Authorization');
    }
  }
}

/// Authentication Interceptor for handling auth tokens
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    // This will be implemented when auth system is ready
    // options.headers['Authorization'] = 'Bearer $token';
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401/403 errors by refreshing token or redirecting to login
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      // Implement token refresh logic here
      // For now, just pass through the error
    }
    
    handler.next(err);
  }
}

/// Retry Interceptor for automatic retry on network failures
class _RetryInterceptor extends Interceptor {
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;
      
      if (retryCount < maxRetries) {
        // Wait before retrying
        await Future.delayed(retryDelay * (retryCount + 1));
        
        // Update retry count
        err.requestOptions.extra['retryCount'] = retryCount + 1;
        
        // Retry the request
        try {
          final response = await Dio().fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (e) {
          // If retry fails, continue with original error
        }
      }
    }
    
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Retry on network errors and server errors
    return err.type == DioExceptionType.connectionError ||
           err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

/// Cache Interceptor for basic response caching
class _CacheInterceptor extends Interceptor {
  static final Map<String, _CacheEntry> _cache = {};
  static const Duration defaultCacheDuration = Duration(minutes: 5);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Skip caching for non-GET requests
    if (options.method != 'GET') {
      handler.next(options);
      return;
    }

    // Check if we have a valid cached response
    final cacheKey = _generateCacheKey(options);
    final cachedEntry = _cache[cacheKey];
    
    if (cachedEntry != null && !cachedEntry.isExpired) {
      // Return cached response
      final response = Response(
        data: cachedEntry.data,
        statusCode: 200,
        requestOptions: options,
        headers: cachedEntry.headers,
      );
      handler.resolve(response);
      return;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Cache successful GET responses
    if (response.requestOptions.method == 'GET' && response.statusCode == 200) {
      final cacheKey = _generateCacheKey(response.requestOptions);
      _cache[cacheKey] = _CacheEntry(
        data: response.data,
        headers: response.headers,
        timestamp: DateTime.now(),
        duration: defaultCacheDuration,
      );
    }

    handler.next(response);
  }

  String _generateCacheKey(RequestOptions options) {
    return '${options.method}_${options.path}_${options.queryParameters.hashCode}';
  }

  /// Clear all cached data
  static void clearCache() {
    _cache.clear();
  }

  /// Clear expired cache entries
  static void clearExpiredCache() {
    _cache.removeWhere((key, entry) => entry.isExpired);
  }
}

/// Cache entry for storing response data
class _CacheEntry {
  final dynamic data;
  final Headers headers;
  final DateTime timestamp;
  final Duration duration;

  _CacheEntry({
    required this.data,
    required this.headers,
    required this.timestamp,
    required this.duration,
  });

  bool get isExpired {
    return DateTime.now().difference(timestamp) > duration;
  }
}

/// Error Handling Interceptor for centralized error processing
class _ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log error for debugging
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      print('Dio Error: ${err.type} - ${err.message}');
      if (err.response != null) {
        print('Status: ${err.response!.statusCode}');
        print('Data: ${err.response!.data}');
      }
    }

    // Transform error to include more context
    if (err.response?.data is Map<String, dynamic>) {
      try {
        // Try to parse error response
        final errorData = err.response!.data as Map<String, dynamic>;
        if (errorData.containsKey('message') || errorData.containsKey('error')) {
          // Error is already formatted, pass through
          handler.next(err);
          return;
        }
      } catch (e) {
        // Parsing failed, continue with original error
      }
    }

    handler.next(err);
  }
}
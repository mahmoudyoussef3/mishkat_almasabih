import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'api_error_model.dart';

/// API Error Handler for managing different types of errors
/// Converts Dio errors to ApiErrorModel and provides utility methods
class ApiErrorHandler {
  /// Handle Dio errors and convert them to ApiErrorModel
  /// Returns Left with ApiErrorModel for error cases
  static Either<ApiErrorModel, void> handle(dynamic error) {
    if (error is DioException) {
      return Left(_handleDioError(error));
    } else if (error is ApiErrorModel) {
      return Left(error);
    } else {
      return Left(_handleGenericError(error));
    }
  }

  /// Handle Dio specific errors
  static ApiErrorModel _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiErrorModel(
          statusCode: 408,
          message: 'Request timeout. Please check your connection and try again.',
          error: 'TIMEOUT_ERROR',
          errorCode: 'TIMEOUT',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return ApiErrorModel(
          statusCode: 499,
          message: 'Request was cancelled.',
          error: 'REQUEST_CANCELLED',
          errorCode: 'CANCELLED',
        );

      case DioExceptionType.connectionError:
        return ApiErrorModel(
          statusCode: 0,
          message: 'No internet connection. Please check your network settings.',
          error: 'CONNECTION_ERROR',
          errorCode: 'NO_INTERNET',
        );

      case DioExceptionType.badCertificate:
        return ApiErrorModel(
          statusCode: 0,
          message: 'SSL certificate error. Please try again later.',
          error: 'SSL_ERROR',
          errorCode: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
      default:
        return ApiErrorModel(
          statusCode: 0,
          message: 'An unexpected error occurred. Please try again.',
          error: 'UNKNOWN_ERROR',
          errorCode: 'UNKNOWN',
        );
    }
  }

  /// Handle HTTP response errors
  static ApiErrorModel _handleBadResponse(Response? response) {
    if (response == null) {
      return ApiErrorModel(
        statusCode: 0,
        message: 'No response received from server.',
        error: 'NO_RESPONSE',
        errorCode: 'NO_RESPONSE',
      );
    }

    // Try to parse error from response data
    try {
      if (response.data is Map<String, dynamic>) {
        final errorData = response.data as Map<String, dynamic>;
        return ApiErrorModel.fromJson(errorData);
      }
    } catch (e) {
      // If parsing fails, create generic error
    }

    // Handle specific HTTP status codes
    switch (response.statusCode) {
      case 400:
        return ApiErrorModel(
          statusCode: 400,
          message: 'Bad request. Please check your input and try again.',
          error: 'BAD_REQUEST',
          errorCode: 'BAD_REQUEST',
        );

      case 401:
        return ApiErrorModel(
          statusCode: 401,
          message: 'Unauthorized. Please login to continue.',
          error: 'UNAUTHORIZED',
          errorCode: 'UNAUTHORIZED',
        );

      case 403:
        return ApiErrorModel(
          statusCode: 403,
          message: 'Access forbidden. You don\'t have permission to access this resource.',
          error: 'FORBIDDEN',
          errorCode: 'FORBIDDEN',
        );

      case 404:
        return ApiErrorModel(
          statusCode: 404,
          message: 'Resource not found. The requested item doesn\'t exist.',
          error: 'NOT_FOUND',
          errorCode: 'NOT_FOUND',
        );

      case 409:
        return ApiErrorModel(
          statusCode: 409,
          message: 'Conflict. The resource already exists or has conflicting data.',
          error: 'CONFLICT',
          errorCode: 'CONFLICT',
        );

      case 422:
        return ApiErrorModel(
          statusCode: 422,
          message: 'Validation failed. Please check your input and try again.',
          error: 'VALIDATION_ERROR',
          errorCode: 'VALIDATION_FAILED',
        );

      case 429:
        return ApiErrorModel(
          statusCode: 429,
          message: 'Too many requests. Please wait a moment and try again.',
          error: 'RATE_LIMIT',
          errorCode: 'RATE_LIMIT_EXCEEDED',
        );

      case 500:
        return ApiErrorModel(
          statusCode: 500,
          message: 'Internal server error. Please try again later.',
          error: 'INTERNAL_SERVER_ERROR',
          errorCode: 'SERVER_ERROR',
        );

      case 502:
        return ApiErrorModel(
          statusCode: 502,
          message: 'Bad gateway. Please try again later.',
          error: 'BAD_GATEWAY',
          errorCode: 'GATEWAY_ERROR',
        );

      case 503:
        return ApiErrorModel(
          statusCode: 503,
          message: 'Service unavailable. Please try again later.',
          error: 'SERVICE_UNAVAILABLE',
          errorCode: 'SERVICE_DOWN',
        );

      case 504:
        return ApiErrorModel(
          statusCode: 504,
          message: 'Gateway timeout. Please try again later.',
          error: 'GATEWAY_TIMEOUT',
          errorCode: 'GATEWAY_TIMEOUT',
        );

      default:
        return ApiErrorModel(
          statusCode: response.statusCode,
          message: 'HTTP ${response.statusCode} error occurred.',
          error: 'HTTP_ERROR',
          errorCode: 'HTTP_${response.statusCode}',
        );
    }
  }

  /// Handle generic errors
  static ApiErrorModel _handleGenericError(dynamic error) {
    if (error is String) {
      return ApiErrorModel(
        statusCode: 0,
        message: error,
        error: 'GENERIC_ERROR',
        errorCode: 'GENERIC',
      );
    }

    return ApiErrorModel(
      statusCode: 0,
      message: error.toString(),
      error: 'GENERIC_ERROR',
      errorCode: 'GENERIC',
    );
  }

  /// Check if error is retryable
  static bool isRetryable(ApiErrorModel error) {
    // Retry on network errors and server errors (5xx)
    return error.isNetworkError || 
           (error.statusCode != null && error.statusCode! >= 500);
  }

  /// Get retry delay based on error type
  static Duration getRetryDelay(ApiErrorModel error, int attempt) {
    if (error.statusCode == 429) {
      // Rate limit: exponential backoff
      return Duration(seconds: (2 * attempt).clamp(1, 60));
    }
    
    if (isRetryable(error)) {
      // Network/server error: exponential backoff
      return Duration(seconds: (1 * attempt).clamp(1, 30));
    }
    
    // Non-retryable error
    return Duration.zero;
  }

  /// Check if error requires user action
  static bool requiresUserAction(ApiErrorModel error) {
    return error.isAuthError || 
           error.isValidationError || 
           error.statusCode == 403;
  }

  /// Check if error should show retry button
  static bool shouldShowRetry(ApiErrorModel error) {
    return isRetryable(error) && !requiresUserAction(error);
  }
}
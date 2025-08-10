import 'package:json_annotation/json_annotation.dart';

part 'api_error_model.g.dart';

/// API Error Model for handling server-side errors
/// Contains error details returned from the API
@JsonSerializable()
class ApiErrorModel {
  /// HTTP status code of the error
  @JsonKey(name: 'status_code')
  final int? statusCode;
  
  /// Error message from the server
  @JsonKey(name: 'message')
  final String? message;
  
  /// Detailed error description
  @JsonKey(name: 'error')
  final String? error;
  
  /// Error code for client-side handling
  @JsonKey(name: 'error_code')
  final String? errorCode;
  
  /// Timestamp when the error occurred
  @JsonKey(name: 'timestamp')
  final String? timestamp;
  
  /// Path that caused the error
  @JsonKey(name: 'path')
  final String? path;
  
  /// Additional error details
  @JsonKey(name: 'details')
  final Map<String, dynamic>? details;
  
  /// Validation errors if any
  @JsonKey(name: 'validation_errors')
  final List<ValidationError>? validationErrors;

  const ApiErrorModel({
    this.statusCode,
    this.message,
    this.error,
    this.errorCode,
    this.timestamp,
    this.path,
    this.details,
    this.validationErrors,
  });

  /// Create ApiErrorModel from JSON
  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  /// Convert ApiErrorModel to JSON
  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);

  /// Get the primary error message
  String get primaryMessage {
    return message ?? error ?? 'An unknown error occurred';
  }

  /// Check if this is a validation error
  bool get isValidationError => validationErrors?.isNotEmpty == true;

  /// Check if this is a network error
  bool get isNetworkError => statusCode == null || statusCode! >= 500;

  /// Check if this is a client error (4xx)
  bool get isClientError => statusCode != null && statusCode! >= 400 && statusCode! < 500;

  /// Check if this is an authentication error
  bool get isAuthError => statusCode == 401 || statusCode == 403;

  /// Check if this is a not found error
  bool get isNotFoundError => statusCode == 404;

  /// Get formatted error message for display
  String get displayMessage {
    if (isValidationError) {
      return 'Please check your input and try again';
    }
    if (isNetworkError) {
      return 'Network error. Please check your connection and try again';
    }
    if (isAuthError) {
      return 'Authentication failed. Please login again';
    }
    if (isNotFoundError) {
      return 'The requested resource was not found';
    }
    return primaryMessage;
  }

  @override
  String toString() {
    return 'ApiErrorModel(statusCode: $statusCode, message: $message, error: $error)';
  }
}

/// Validation Error Model for form validation errors
@JsonSerializable()
class ValidationError {
  /// Field name that has validation error
  @JsonKey(name: 'field')
  final String? field;
  
  /// Validation error message
  @JsonKey(name: 'message')
  final String? message;
  
  /// Validation error code
  @JsonKey(name: 'code')
  final String? code;
  
  /// Rejected value that caused validation error
  @JsonKey(name: 'rejected_value')
  final dynamic rejectedValue;

  const ValidationError({
    this.field,
    this.message,
    this.code,
    this.rejectedValue,
  });

  /// Create ValidationError from JSON
  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);

  /// Convert ValidationError to JSON
  Map<String, dynamic> toJson() => _$ValidationErrorToJson(this);

  @override
  String toString() {
    return 'ValidationError(field: $field, message: $message)';
  }
}
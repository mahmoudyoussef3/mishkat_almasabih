import 'package:dartz/dartz.dart';

import 'api_error_handler.dart';

/// A helper class to wrap API results using Either.
/// - Left = Failure (ErrorHandler)
/// - Right = Success (T)
class ApiResult<T> {
  final Either<ErrorHandler, T> _result;

  ApiResult._(this._result);

  /// Success case
  factory ApiResult.success(T data) {
    return ApiResult._(Right(data));
  }

  /// Failure case
  factory ApiResult.failure(ErrorHandler errorHandler) {
    return ApiResult._(Left(errorHandler));
  }

  /// Access the raw Either if needed
  Either<ErrorHandler, T> get result => _result;
}

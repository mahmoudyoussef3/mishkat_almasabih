// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiErrorModel _$ApiErrorModelFromJson(Map<String, dynamic> json) =>
    ApiErrorModel(
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      error: json['error'] as String?,
      errorCode: json['error_code'] as String?,
      timestamp: json['timestamp'] as String?,
      path: json['path'] as String?,
      details: json['details'] as Map<String, dynamic>?,
      validationErrors:
          (json['validation_errors'] as List<dynamic>?)
              ?.map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ApiErrorModelToJson(ApiErrorModel instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'message': instance.message,
      'error': instance.error,
      'error_code': instance.errorCode,
      'timestamp': instance.timestamp,
      'path': instance.path,
      'details': instance.details,
      'validation_errors': instance.validationErrors,
    };

ValidationError _$ValidationErrorFromJson(Map<String, dynamic> json) =>
    ValidationError(
      field: json['field'] as String?,
      message: json['message'] as String?,
      code: json['code'] as String?,
      rejectedValue: json['rejected_value'],
    );

Map<String, dynamic> _$ValidationErrorToJson(ValidationError instance) =>
    <String, dynamic>{
      'field': instance.field,
      'message': instance.message,
      'code': instance.code,
      'rejected_value': instance.rejectedValue,
    };

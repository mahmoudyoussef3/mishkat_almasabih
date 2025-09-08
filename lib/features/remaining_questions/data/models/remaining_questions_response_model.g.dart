// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remaining_questions_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RmainingQuestionsResponse _$RmainingQuestionsResponseFromJson(
  Map<String, dynamic> json,
) => RmainingQuestionsResponse(
  remaining: (json['remaining'] as num?)?.toInt(),
  resetTime: json['resetTime'] as String?,
  max: (json['max'] as num?)?.toInt(),
  currentCount: (json['currentCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$RmainingQuestionsResponseToJson(
  RmainingQuestionsResponse instance,
) => <String, dynamic>{
  'remaining': instance.remaining,
  'resetTime': instance.resetTime,
  'max': instance.max,
  'currentCount': instance.currentCount,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_analysis_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HadithAnalysisRequest _$HadithAnalysisRequestFromJson(
  Map<String, dynamic> json,
) => HadithAnalysisRequest(
  hadeeth: json['hadeeth'] as String,
  attribution: json['attribution'] as String,
  grade: json['grade'] as String,
  reference: json['reference'] as String,
);

Map<String, dynamic> _$HadithAnalysisRequestToJson(
  HadithAnalysisRequest instance,
) => <String, dynamic>{
  'hadeeth': instance.hadeeth,
  'attribution': instance.attribution,
  'grade': instance.grade,
  'reference': instance.reference,
};

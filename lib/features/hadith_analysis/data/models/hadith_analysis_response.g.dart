// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_analysis_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HadithAnalysisResponse _$HadithAnalysisResponseFromJson(
  Map<String, dynamic> json,
) => HadithAnalysisResponse(
  hadith: json['hadith'] as String?,
  attribution: json['attribution'] as String?,
  analysis: json['analysis'] as String?,
  timestamp: json['timestamp'] as String?,
);

Map<String, dynamic> _$HadithAnalysisResponseToJson(
  HadithAnalysisResponse instance,
) => <String, dynamic>{
  'hadith': instance.hadith,
  'attribution': instance.attribution,
  'analysis': instance.analysis,
  'timestamp': instance.timestamp,
};

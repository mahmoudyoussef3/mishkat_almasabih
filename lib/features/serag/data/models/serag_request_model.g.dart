// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serag_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeragRequestModel _$SeragRequestModelFromJson(Map<String, dynamic> json) =>
    SeragRequestModel(
      hadeeth: json['hadeeth'] as String,
      attribution: json['attribution'] as String,
      grade_ar: json['grade_ar'] as String,
      takhrig_ar: json['takhrig_ar'] as String,
      source: json['source'] as String,
      reference: json['reference'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$SeragRequestModelToJson(SeragRequestModel instance) =>
    <String, dynamic>{
      'hadeeth': instance.hadeeth,
      'attribution': instance.attribution,
      'grade_ar': instance.grade_ar,
      'source': instance.source,
      'takhrig_ar': instance.takhrig_ar,
      'reference': instance.reference,
      'message': instance.message,
    };

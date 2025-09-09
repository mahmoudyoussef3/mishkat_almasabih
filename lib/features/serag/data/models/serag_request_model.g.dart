// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serag_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeragRequestModel _$SeragRequestModelFromJson(Map<String, dynamic> json) =>
    SeragRequestModel(
      hadith: Hadith.fromJson(json['hadith'] as Map<String, dynamic>),
      messages:
          (json['messages'] as List<dynamic>)
              .map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$SeragRequestModelToJson(SeragRequestModel instance) =>
    <String, dynamic>{
      'hadith': instance.hadith.toJson(),
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };

Hadith _$HadithFromJson(Map<String, dynamic> json) => Hadith(
  hadeeth: json['hadeeth'] as String,
  grade_ar: json['grade_ar'] as String,
  source: json['source'] as String,
  sharh: json['sharh'] as String,
  takhrij_ar: json['takhrij_ar'] as String,
);

Map<String, dynamic> _$HadithToJson(Hadith instance) => <String, dynamic>{
  'hadeeth': instance.hadeeth,
  'grade_ar': instance.grade_ar,
  'source': instance.source,
  'takhrij_ar': instance.takhrij_ar,
  'sharh': instance.sharh,
};

Message _$MessageFromJson(Map<String, dynamic> json) =>
    Message(role: json['role'] as String, content: json['content'] as String);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'role': instance.role,
  'content': instance.content,
};

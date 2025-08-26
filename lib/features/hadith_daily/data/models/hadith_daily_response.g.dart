// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_daily_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyHadithModel _$DailyHadithModelFromJson(Map<String, dynamic> json) =>
    DailyHadithModel(
      status: json['status'] as bool?,
      data:
          json['data'] == null
              ? null
              : HadithData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DailyHadithModelToJson(DailyHadithModel instance) =>
    <String, dynamic>{'status': instance.status, 'data': instance.data};

HadithData _$HadithDataFromJson(Map<String, dynamic> json) => HadithData(
  title: json['title'] as String?,
  hadith: json['hadith'] as String?,
  attribution: json['attribution'] as String?,
  grade: json['grade'] as String?,
  explanation: json['explanation'] as String?,
  hints: (json['hints'] as List<dynamic>?)?.map((e) => e as String).toList(),
  wordsMeanings:
      (json['wordsMeanings'] as List<dynamic>?)
          ?.map((e) => WordMeaning.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$HadithDataToJson(HadithData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'hadith': instance.hadith,
      'attribution': instance.attribution,
      'grade': instance.grade,
      'explanation': instance.explanation,
      'hints': instance.hints,
      'wordsMeanings': instance.wordsMeanings,
    };

WordMeaning _$WordMeaningFromJson(Map<String, dynamic> json) => WordMeaning(
  word: json['word'] as String?,
  meaning: json['meaning'] as String?,
);

Map<String, dynamic> _$WordMeaningToJson(WordMeaning instance) =>
    <String, dynamic>{'word': instance.word, 'meaning': instance.meaning};

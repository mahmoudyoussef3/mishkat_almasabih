// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_ahadith_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RandomAhadithResponse _$RandomAhadithResponseFromJson(
  Map<String, dynamic> json,
) => RandomAhadithResponse(
  hadiths:
      (json['hadiths'] as List<dynamic>?)
          ?.map((e) => RandomHadithModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$RandomAhadithResponseToJson(
  RandomAhadithResponse instance,
) => <String, dynamic>{
  'hadiths': instance.hadiths?.map((e) => e.toJson()).toList(),
};

RandomHadithModel _$RandomHadithModelFromJson(
  Map<String, dynamic> json,
) => RandomHadithModel(
  hadithId: json['hadithId'] as String?,
  hadith: json['hadith'] as String?,
  title: json['title'] as String?,
  attribution: json['attribution'] as String?,
  grade: json['grade'] as String?,
  explanation: json['explanation'] as String?,
  hints: (json['hints'] as List<dynamic>?)?.map((e) => e as String).toList(),
  categoriesIds:
      (json['categoriesIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  words_meanings:
      (json['words_meanings'] as List<dynamic>?)
          ?.map((e) => WordMeaning.fromJson(e as Map<String, dynamic>))
          .toList(),
  reference: json['reference'] as String?,
  language: json['language'] as String?,
  categories:
      (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$RandomHadithModelToJson(
  RandomHadithModel instance,
) => <String, dynamic>{
  'hadithId': instance.hadithId,
  'hadith': instance.hadith,
  'title': instance.title,
  'attribution': instance.attribution,
  'grade': instance.grade,
  'explanation': instance.explanation,
  'hints': instance.hints,
  'categoriesIds': instance.categoriesIds,
  'words_meanings': instance.words_meanings?.map((e) => e.toJson()).toList(),
  'reference': instance.reference,
  'language': instance.language,
  'categories': instance.categories,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapters_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChaptersModel _$ChaptersModelFromJson(Map<String, dynamic> json) =>
    ChaptersModel(
      status: (json['status'] as num?)?.toInt(),
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((e) => Chapter.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ChaptersModelToJson(ChaptersModel instance) =>
    <String, dynamic>{'status': instance.status, 'chapters': instance.chapters};

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
  chapterNumber: Chapter._toInt(json['chapterNumber']),
  chapterArabic: json['chapterArabic'] as String?,
  chapterEnglish: json['chapterEnglish'] as String?,
  chapterUrdu: json['chapterUrdu'] as String?,
  hadithsCount: Chapter._toInt(json['hadiths_count']),
);

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
  'chapterNumber': instance.chapterNumber,
  'chapterArabic': instance.chapterArabic,
  'chapterEnglish': instance.chapterEnglish,
  'chapterUrdu': instance.chapterUrdu,
  'hadiths_count': instance.hadithsCount,
};

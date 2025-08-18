// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_chapters_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookChaptersModel _$BookChaptersModelFromJson(Map<String, dynamic> json) =>
    BookChaptersModel(
      status: (json['status'] as num?)?.toInt(),
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((e) => Chapter.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$BookChaptersModelToJson(BookChaptersModel instance) =>
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

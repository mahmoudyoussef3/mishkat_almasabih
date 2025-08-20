// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_ahadiths_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HadithResponse _$HadithResponseFromJson(Map<String, dynamic> json) =>
    HadithResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      hadiths:
          json['hadiths'] == null
              ? null
              : Hadiths.fromJson(json['hadiths'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HadithResponseToJson(HadithResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'hadiths': instance.hadiths,
    };

Hadiths _$HadithsFromJson(Map<String, dynamic> json) => Hadiths(
  current_page: (json['current_page'] as num?)?.toInt(),
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => Hadith.fromJson(e as Map<String, dynamic>))
          .toList(),
  first_page_url: json['first_page_url'] as String?,
  from: (json['from'] as num?)?.toInt(),
  last_page: (json['last_page'] as num?)?.toInt(),
  last_page_url: json['last_page_url'] as String?,
  links:
      (json['links'] as List<dynamic>?)
          ?.map((e) => HadithLink.fromJson(e as Map<String, dynamic>))
          .toList(),
  next_page_url: json['next_page_url'] as String?,
  path: json['path'] as String?,
  per_page: json['per_page'] as String?,
  prev_page_url: json['prev_page_url'] as String?,
  to: (json['to'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$HadithsToJson(Hadiths instance) => <String, dynamic>{
  'current_page': instance.current_page,
  'data': instance.data,
  'first_page_url': instance.first_page_url,
  'from': instance.from,
  'last_page': instance.last_page,
  'last_page_url': instance.last_page_url,
  'links': instance.links,
  'next_page_url': instance.next_page_url,
  'path': instance.path,
  'per_page': instance.per_page,
  'prev_page_url': instance.prev_page_url,
  'to': instance.to,
  'total': instance.total,
};

Hadith _$HadithFromJson(Map<String, dynamic> json) => Hadith(
  id: (json['id'] as num?)?.toInt(),
  hadithNumber: json['hadithNumber'] as String?,
  englishNarrator: json['englishNarrator'] as String?,
  hadithEnglish: json['hadithEnglish'] as String?,
  hadithUrdu: json['hadithUrdu'] as String?,
  urduNarrator: json['urduNarrator'] as String?,
  hadithArabic: json['hadithArabic'] as String?,
  headingArabic: json['headingArabic'] as String?,
  headingUrdu: json['headingUrdu'] as String?,
  headingEnglish: json['headingEnglish'] as String?,
  chapterId: json['chapterId'] as String?,
  bookSlug: json['bookSlug'] as String?,
  volume: json['volume'] as String?,
  status: json['status'] as String?,
  book:
      json['book'] == null
          ? null
          : HadithBook.fromJson(json['book'] as Map<String, dynamic>),
  chapter:
      json['chapter'] == null
          ? null
          : HadithChapter.fromJson(json['chapter'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HadithToJson(Hadith instance) => <String, dynamic>{
  'id': instance.id,
  'hadithNumber': instance.hadithNumber,
  'englishNarrator': instance.englishNarrator,
  'hadithEnglish': instance.hadithEnglish,
  'hadithUrdu': instance.hadithUrdu,
  'urduNarrator': instance.urduNarrator,
  'hadithArabic': instance.hadithArabic,
  'headingArabic': instance.headingArabic,
  'headingUrdu': instance.headingUrdu,
  'headingEnglish': instance.headingEnglish,
  'chapterId': instance.chapterId,
  'bookSlug': instance.bookSlug,
  'volume': instance.volume,
  'status': instance.status,
  'book': instance.book,
  'chapter': instance.chapter,
};

HadithBook _$HadithBookFromJson(Map<String, dynamic> json) => HadithBook(
  id: (json['id'] as num?)?.toInt(),
  bookName: json['bookName'] as String?,
  writerName: json['writerName'] as String?,
  aboutWriter: json['aboutWriter'] as String?,
  writerDeath: json['writerDeath'] as String?,
  bookSlug: json['bookSlug'] as String?,
);

Map<String, dynamic> _$HadithBookToJson(HadithBook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookName': instance.bookName,
      'writerName': instance.writerName,
      'aboutWriter': instance.aboutWriter,
      'writerDeath': instance.writerDeath,
      'bookSlug': instance.bookSlug,
    };

HadithChapter _$HadithChapterFromJson(Map<String, dynamic> json) =>
    HadithChapter(
      id: (json['id'] as num?)?.toInt(),
      chapterNumber: json['chapterNumber'] as String?,
      chapterEnglish: json['chapterEnglish'] as String?,
      chapterUrdu: json['chapterUrdu'] as String?,
      chapterArabic: json['chapterArabic'] as String?,
      bookSlug: json['bookSlug'] as String?,
    );

Map<String, dynamic> _$HadithChapterToJson(HadithChapter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapterNumber': instance.chapterNumber,
      'chapterEnglish': instance.chapterEnglish,
      'chapterUrdu': instance.chapterUrdu,
      'chapterArabic': instance.chapterArabic,
      'bookSlug': instance.bookSlug,
    };

HadithLink _$HadithLinkFromJson(Map<String, dynamic> json) => HadithLink(
  url: json['url'] as String?,
  label: json['label'] as String?,
  active: json['active'] as bool?,
);

Map<String, dynamic> _$HadithLinkToJson(HadithLink instance) =>
    <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'active': instance.active,
    };

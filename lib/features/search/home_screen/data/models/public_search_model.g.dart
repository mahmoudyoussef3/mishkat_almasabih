// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    SearchResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      search:
          json['search'] == null
              ? null
              : Search.fromJson(json['search'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'search': instance.search?.toJson(),
    };

Search _$SearchFromJson(Map<String, dynamic> json) => Search(
  query: json['query'] as String?,
  filters: json['filters'] as Map<String, dynamic>?,
  sort:
      json['sort'] == null
          ? null
          : Sort.fromJson(json['sort'] as Map<String, dynamic>),
  results:
      json['results'] == null
          ? null
          : Results.fromJson(json['results'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SearchToJson(Search instance) => <String, dynamic>{
  'query': instance.query,
  'filters': instance.filters,
  'sort': instance.sort?.toJson(),
  'results': instance.results?.toJson(),
};

Sort _$SortFromJson(Map<String, dynamic> json) =>
    Sort(field: json['field'] as String?, order: json['order'] as String?);

Map<String, dynamic> _$SortToJson(Sort instance) => <String, dynamic>{
  'field': instance.field,
  'order': instance.order,
};

Results _$ResultsFromJson(Map<String, dynamic> json) => Results(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => HadithData.fromJson(e as Map<String, dynamic>))
          .toList(),
  currentPage: (json['current_page'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  from: (json['from'] as num?)?.toInt(),
  to: (json['to'] as num?)?.toInt(),
  nextPageUrl: json['next_page_url'] as String?,
  prevPageUrl: json['prev_page_url'] as String?,
);

Map<String, dynamic> _$ResultsToJson(Results instance) => <String, dynamic>{
  'data': instance.data?.map((e) => e.toJson()).toList(),
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'per_page': instance.perPage,
  'total': instance.total,
  'from': instance.from,
  'to': instance.to,
  'next_page_url': instance.nextPageUrl,
  'prev_page_url': instance.prevPageUrl,
};

HadithData _$HadithDataFromJson(Map<String, dynamic> json) => HadithData(
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
          : Book.fromJson(json['book'] as Map<String, dynamic>),
  chapter:
      json['chapter'] == null
          ? null
          : Chapter.fromJson(json['chapter'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HadithDataToJson(HadithData instance) =>
    <String, dynamic>{
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
      'book': instance.book?.toJson(),
      'chapter': instance.chapter?.toJson(),
    };

Book _$BookFromJson(Map<String, dynamic> json) => Book(
  id: (json['id'] as num?)?.toInt(),
  bookName: json['bookName'] as String?,
  writerName: json['writerName'] as String?,
  aboutWriter: json['aboutWriter'] as String?,
  writerDeath: json['writerDeath'] as String?,
  bookSlug: json['bookSlug'] as String?,
);

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
  'id': instance.id,
  'bookName': instance.bookName,
  'writerName': instance.writerName,
  'aboutWriter': instance.aboutWriter,
  'writerDeath': instance.writerDeath,
  'bookSlug': instance.bookSlug,
};

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
  id: (json['id'] as num?)?.toInt(),
  chapterNumber: json['chapterNumber'] as String?,
  chapterEnglish: json['chapterEnglish'] as String?,
  chapterUrdu: json['chapterUrdu'] as String?,
  chapterArabic: json['chapterArabic'] as String?,
  bookSlug: json['bookSlug'] as String?,
);

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
  'id': instance.id,
  'chapterNumber': instance.chapterNumber,
  'chapterEnglish': instance.chapterEnglish,
  'chapterUrdu': instance.chapterUrdu,
  'chapterArabic': instance.chapterArabic,
  'bookSlug': instance.bookSlug,
};

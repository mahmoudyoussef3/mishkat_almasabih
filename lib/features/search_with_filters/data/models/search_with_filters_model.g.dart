// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_with_filters_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchWithFiltersModel _$SearchWithFiltersModelFromJson(
  Map<String, dynamic> json,
) => SearchWithFiltersModel(
  status: (json['status'] as num?)?.toInt(),
  message: json['message'] as String?,
  search:
      json['search'] == null
          ? null
          : SearchData.fromJson(json['search'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SearchWithFiltersModelToJson(
  SearchWithFiltersModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'search': instance.search,
};

SearchData _$SearchDataFromJson(Map<String, dynamic> json) => SearchData(
  query: json['query'] as String?,
  filters:
      json['filters'] == null
          ? null
          : SearchFilters.fromJson(json['filters'] as Map<String, dynamic>),
  sort:
      json['sort'] == null
          ? null
          : SearchSort.fromJson(json['sort'] as Map<String, dynamic>),
  results:
      json['results'] == null
          ? null
          : SearchResults.fromJson(json['results'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SearchDataToJson(SearchData instance) =>
    <String, dynamic>{
      'query': instance.query,
      'filters': instance.filters,
      'sort': instance.sort,
      'results': instance.results,
    };

SearchFilters _$SearchFiltersFromJson(Map<String, dynamic> json) =>
    SearchFilters(
      book: json['book'] as String?,
      category: json['category'] as String?,
      narrator: json['narrator'] as String?,
      status: json['status'] as String?,
      chapter: json['chapter'] as String?,
    );

Map<String, dynamic> _$SearchFiltersToJson(SearchFilters instance) =>
    <String, dynamic>{
      'book': instance.book,
      'category': instance.category,
      'narrator': instance.narrator,
      'status': instance.status,
      'chapter': instance.chapter,
    };

SearchSort _$SearchSortFromJson(Map<String, dynamic> json) => SearchSort(
  field: json['field'] as String?,
  order: json['order'] as String?,
);

Map<String, dynamic> _$SearchSortToJson(SearchSort instance) =>
    <String, dynamic>{'field': instance.field, 'order': instance.order};

SearchResults _$SearchResultsFromJson(Map<String, dynamic> json) =>
    SearchResults(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => HadithResult.fromJson(e as Map<String, dynamic>))
              .toList(),
      currentPage: (json['currentPage'] as num?)?.toInt(),
      lastPage: (json['lastPage'] as num?)?.toInt(),
      perPage: (json['perPage'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      from: (json['from'] as num?)?.toInt(),
      to: (json['to'] as num?)?.toInt(),
      nextPageUrl: json['nextPageUrl'] as String?,
      prevPageUrl: json['prevPageUrl'] as String?,
    );

Map<String, dynamic> _$SearchResultsToJson(SearchResults instance) =>
    <String, dynamic>{
      'data': instance.data,
      'currentPage': instance.currentPage,
      'lastPage': instance.lastPage,
      'perPage': instance.perPage,
      'total': instance.total,
      'from': instance.from,
      'to': instance.to,
      'nextPageUrl': instance.nextPageUrl,
      'prevPageUrl': instance.prevPageUrl,
    };

HadithResult _$HadithResultFromJson(Map<String, dynamic> json) => HadithResult(
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

Map<String, dynamic> _$HadithResultToJson(HadithResult instance) =>
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
      'book': instance.book,
      'chapter': instance.chapter,
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

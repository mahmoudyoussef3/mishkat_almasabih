// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhanced_search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnhancedSearch _$EnhancedSearchFromJson(Map<String, dynamic> json) =>
    EnhancedSearch(
      success: json['success'] as bool?,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => HadithModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      pagination:
          json['pagination'] == null
              ? null
              : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EnhancedSearchToJson(EnhancedSearch instance) =>
    <String, dynamic>{
      'success': instance.success,
      'results': instance.results,
      'pagination': instance.pagination,
    };

HadithModel _$HadithModelFromJson(Map<String, dynamic> json) => HadithModel(
  id: json['id'] as String?,
  title: json['title'] as String?,
  hadeeth: json['hadeeth'] as String?,
  attribution: json['attribution'] as String?,
  grade: json['grade'] as String?,
  explanation: json['explanation'] as String?,
  hints: (json['hints'] as List<dynamic>?)?.map((e) => e as String).toList(),
  categories:
      (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList(),
  hadeethIntro: json['hadeethIntro'] as String?,
  wordsMeanings:
      (json['wordsMeanings'] as List<dynamic>?)
          ?.map((e) => WordMeaning.fromJson(e as Map<String, dynamic>))
          .toList(),
  reference: json['reference'] as String?,
);

Map<String, dynamic> _$HadithModelToJson(HadithModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'hadeeth': instance.hadeeth,
      'attribution': instance.attribution,
      'grade': instance.grade,
      'explanation': instance.explanation,
      'hints': instance.hints,
      'categories': instance.categories,
      'hadeethIntro': instance.hadeethIntro,
      'wordsMeanings': instance.wordsMeanings,
      'reference': instance.reference,
    };

WordMeaning _$WordMeaningFromJson(Map<String, dynamic> json) => WordMeaning(
  word: json['word'] as String?,
  meaning: json['meaning'] as String?,
);

Map<String, dynamic> _$WordMeaningToJson(WordMeaning instance) =>
    <String, dynamic>{'word': instance.word, 'meaning': instance.meaning};

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  total: (json['total'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  currentPage: (json['currentPage'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
  hasNextPage: json['hasNextPage'] as bool?,
  hasPrevPage: json['hasPrevPage'] as bool?,
  resultsInPage: (json['resultsInPage'] as num?)?.toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'total': instance.total,
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'limit': instance.limit,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
      'resultsInPage': instance.resultsInPage,
    };

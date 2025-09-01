import 'package:json_annotation/json_annotation.dart';
part 'search_with_filters_model.g.dart';

@JsonSerializable()
class SearchWithFiltersModel {
  final int? status;
  final String? message;
  final SearchData? search;

  SearchWithFiltersModel({this.status, this.message, this.search});

  factory SearchWithFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$SearchWithFiltersModelFromJson(json);
}

@JsonSerializable()
class SearchData {
  final String? query;
  final SearchFilters? filters;
  final SearchSort? sort;
  final SearchResults? results;

  SearchData({this.query, this.filters, this.sort, this.results});

  factory SearchData.fromJson(Map<String, dynamic> json) =>
      _$SearchDataFromJson(json);
}

@JsonSerializable()
class SearchFilters {
  final String? book;
  final String? category;
  final String? narrator;
  final String? status;
  final String? chapter;

  SearchFilters({this.book, this.category, this.narrator, this.status, this.chapter});

  factory SearchFilters.fromJson(Map<String, dynamic> json) =>
      _$SearchFiltersFromJson(json);
}

@JsonSerializable()
class SearchSort {
  final String? field;
  final String? order;

  SearchSort({this.field, this.order});

  factory SearchSort.fromJson(Map<String, dynamic> json) =>
      _$SearchSortFromJson(json);
}

@JsonSerializable()
class SearchResults {
  final List<HadithResult>? data;
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;
  final int? from;
  final int? to;
  final String? nextPageUrl;
  final String? prevPageUrl;

  SearchResults({
    this.data,
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) =>
      _$SearchResultsFromJson(json);
}

@JsonSerializable()
class HadithResult {
  final int? id;
  final String? hadithNumber;
  final String? englishNarrator;
  final String? hadithEnglish;
  final String? hadithUrdu;
  final String? urduNarrator;
  final String? hadithArabic;
  final String? headingArabic;
  final String? headingUrdu;
  final String? headingEnglish;
  final String? chapterId;
  final String? bookSlug;
  final String? volume;
  final String? status;
  final Book? book;
  final Chapter? chapter;

  HadithResult({
    this.id,
    this.hadithNumber,
    this.englishNarrator,
    this.hadithEnglish,
    this.hadithUrdu,
    this.urduNarrator,
    this.hadithArabic,
    this.headingArabic,
    this.headingUrdu,
    this.headingEnglish,
    this.chapterId,
    this.bookSlug,
    this.volume,
    this.status,
    this.book,
    this.chapter,
  });

  factory HadithResult.fromJson(Map<String, dynamic> json) =>
      _$HadithResultFromJson(json);
}

@JsonSerializable()
class Book {
  final int? id;
  final String? bookName;
  final String? writerName;
  final String? aboutWriter;
  final String? writerDeath;
  final String? bookSlug;

  Book({
    this.id,
    this.bookName,
    this.writerName,
    this.aboutWriter,
    this.writerDeath,
    this.bookSlug,
  });

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}

@JsonSerializable()
class Chapter {
  final int? id;
  final String? chapterNumber;
  final String? chapterEnglish;
  final String? chapterUrdu;
  final String? chapterArabic;
  final String? bookSlug;

  Chapter({
    this.id,
    this.chapterNumber,
    this.chapterEnglish,
    this.chapterUrdu,
    this.chapterArabic,
    this.bookSlug,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}

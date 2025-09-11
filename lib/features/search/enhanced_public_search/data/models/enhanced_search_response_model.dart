import 'package:json_annotation/json_annotation.dart';

part 'enhanced_search_response_model.g.dart';

@JsonSerializable()
class EnhancedSearch {
  final bool? success;

  final List<EnhancedHadithModel>? results;

  final Pagination? pagination;

  EnhancedSearch({this.success, this.results, this.pagination});

  factory EnhancedSearch.fromJson(Map<String, dynamic> json) =>
      _$EnhancedSearchFromJson(json);

  Map<String, dynamic> toJson() => _$EnhancedSearchToJson(this);
}

@JsonSerializable()
class EnhancedHadithModel {
  final String? id;

  final String? title;

  final String? hadeeth;

  final String? attribution;

  final String? grade;

  final String? explanation;

  final List<String>? hints;

  final List<String>? categories;

  final String? hadeethIntro;

  final List<WordMeaning>? words_meanings;

  final String? reference;

  EnhancedHadithModel({
    this.id,
    this.title,
    this.hadeeth,
    this.attribution,
    this.grade,
    this.explanation,
    this.hints,
    this.categories,
    this.hadeethIntro,
    this.words_meanings,
    this.reference,
  });

  factory EnhancedHadithModel.fromJson(Map<String, dynamic> json) =>
      _$EnhancedHadithModelFromJson(json);

  Map<String, dynamic> toJson() => _$EnhancedHadithModelToJson(this);
}

@JsonSerializable()
class WordMeaning {
  final String? word;

  final String? meaning;

  WordMeaning({this.word, this.meaning});

  factory WordMeaning.fromJson(Map<String, dynamic> json) =>
      _$WordMeaningFromJson(json);

  Map<String, dynamic> toJson() => _$WordMeaningToJson(this);
}

@JsonSerializable()
class Pagination {
  final int? total;

  final int? totalPages;

  final int? currentPage;

  final int? limit;

  final bool? hasNextPage;

  final bool? hasPrevPage;

  final int? resultsInPage;

  Pagination({
    this.total,
    this.totalPages,
    this.currentPage,
    this.limit,
    this.hasNextPage,
    this.hasPrevPage,
    this.resultsInPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}

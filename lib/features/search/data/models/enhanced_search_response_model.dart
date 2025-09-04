import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'enhanced_search_response_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class EnhancedSearch {
  @HiveField(0)
  final bool? success;

  @HiveField(1)
  final List<HadithModel>? results;

  @HiveField(2)
  final Pagination? pagination;

  EnhancedSearch({this.success, this.results, this.pagination});

  factory EnhancedSearch.fromJson(Map<String, dynamic> json) =>
      _$EnhancedSearchFromJson(json);

  Map<String, dynamic> toJson() => _$EnhancedSearchToJson(this);
}

@HiveType(typeId: 1)
@JsonSerializable()
class HadithModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? hadeeth;

  @HiveField(3)
  final String? attribution;

  @HiveField(4)
  final String? grade;

  @HiveField(5)
  final String? explanation;

  @HiveField(6)
  final List<String>? hints;

  @HiveField(7)
  final List<String>? categories;

  @HiveField(8)
  final String? hadeethIntro;

  @HiveField(9)
  final List<WordMeaning>? wordsMeanings;

  @HiveField(10)
  final String? reference;

  HadithModel({
    this.id,
    this.title,
    this.hadeeth,
    this.attribution,
    this.grade,
    this.explanation,
    this.hints,
    this.categories,
    this.hadeethIntro,
    this.wordsMeanings,
    this.reference,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) =>
      _$HadithModelFromJson(json);

  Map<String, dynamic> toJson() => _$HadithModelToJson(this);
}

@HiveType(typeId: 2)
@JsonSerializable()
class WordMeaning {
  @HiveField(0)
  final String? word;

  @HiveField(1)
  final String? meaning;

  WordMeaning({this.word, this.meaning});

  factory WordMeaning.fromJson(Map<String, dynamic> json) =>
      _$WordMeaningFromJson(json);

  Map<String, dynamic> toJson() => _$WordMeaningToJson(this);
}

@HiveType(typeId: 3)
@JsonSerializable()
class Pagination {
  @HiveField(0)
  final int? total;

  @HiveField(1)
  final int? totalPages;

  @HiveField(2)
  final int? currentPage;

  @HiveField(3)
  final int? limit;

  @HiveField(4)
  final bool? hasNextPage;

  @HiveField(5)
  final bool? hasPrevPage;

  @HiveField(6)
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

import 'package:json_annotation/json_annotation.dart';

part 'public_search_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchResponse {
  final int? status;
  final String? message;
  final Search? search;

  SearchResponse({
    this.status,
    this.message,
    this.search,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Search {
  final String? query;
  final Map<String, dynamic>? filters;
  final Sort? sort;
  final Results? results;

  Search({
    this.query,
    this.filters,
    this.sort,
    this.results,
  });

  factory Search.fromJson(Map<String, dynamic> json) =>
      _$SearchFromJson(json);

  Map<String, dynamic> toJson() => _$SearchToJson(this);
}

@JsonSerializable()
class Sort {
  final String? field;
  final String? order;

  Sort({this.field, this.order});

  factory Sort.fromJson(Map<String, dynamic> json) => _$SortFromJson(json);

  Map<String, dynamic> toJson() => _$SortToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Results {
  final List<HadithData>? data;
  @JsonKey(name: "current_page")
  final int? currentPage;
  @JsonKey(name: "last_page")
  final int? lastPage;
  @JsonKey(name: "per_page")
  final int? perPage;
  final int? total;
  final int? from;
  final int? to;
  @JsonKey(name: "next_page_url")
  final String? nextPageUrl;
  @JsonKey(name: "prev_page_url")
  final String? prevPageUrl;

  Results({
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

  factory Results.fromJson(Map<String, dynamic> json) =>
      _$ResultsFromJson(json);

  Map<String, dynamic> toJson() => _$ResultsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class HadithData {
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

  HadithData({
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

  factory HadithData.fromJson(Map<String, dynamic> json) =>
      _$HadithDataFromJson(json);

  Map<String, dynamic> toJson() => _$HadithDataToJson(this);
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

  Map<String, dynamic> toJson() => _$BookToJson(this);
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

  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'local_hadith_navigation_model.g.dart';

@JsonSerializable()
class LocalNavigationHadithResponse {
  final int? status;
  final Book? book;
  final Hadith? nextHadith;
  final Hadith? prevHadith;
  final int? currentHadithNumber;
  final int? totalHadiths;

  LocalNavigationHadithResponse({
    this.status,
    this.book,
    this.nextHadith,
    this.prevHadith,
    this.currentHadithNumber,
    this.totalHadiths,
  });
  factory LocalNavigationHadithResponse.fromJson(Map<String, dynamic> json) =>
      _$LocalNavigationHadithResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LocalNavigationHadithResponseToJson(this);
}

@JsonSerializable()
class Book {
  final String? bookName;
  final String? bookNameEn;

  Book({this.bookName, this.bookNameEn});
  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);
}

@JsonSerializable()
class Hadith {
  final int? id;
  final String? title;

  Hadith({this.id, this.title});
  factory Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);
  Map<String, dynamic> toJson() => _$HadithToJson(this);
}

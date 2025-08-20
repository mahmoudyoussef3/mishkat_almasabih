import 'package:json_annotation/json_annotation.dart';

part 'local_books_model.g.dart';

@JsonSerializable()
class LocalHadithResponse {
  final int? status;
  final String? message;
  final LocalHadithData? data;

  LocalHadithResponse({this.status, this.message, this.data});

  factory LocalHadithResponse.fromJson(Map<String, dynamic> json) =>
      _$HadithResponseFromJson(json);
}

@JsonSerializable()
class LocalHadithData {
  final int? currentPage;
  final List<LocalHadith>? hadiths;
  final int? from;
  final int? to;
  final int? perPage;
  final int? total;

  LocalHadithData({
    this.currentPage,
    this.hadiths,
    this.from,
    this.to,
    this.perPage,
    this.total,
  });
  factory LocalHadithData.fromJson(Map<String, dynamic> json) =>
      _$HadithDataFromJson(json);
}

@JsonSerializable()
class LocalHadith {
  final int? id;
  final String? hadithEnglish;
  final String? hadithUrdu;
  final String? hadithArabic;
  final String? chapterId;
  final String? bookSlug;

  LocalHadith({
    this.id,
    this.hadithEnglish,
    this.hadithUrdu,
    this.hadithArabic,
    this.chapterId,
    this.bookSlug,
  });
  factory LocalHadith.fromJson(Map<String, dynamic> json) =>
      _$HadithFromJson(json);
}

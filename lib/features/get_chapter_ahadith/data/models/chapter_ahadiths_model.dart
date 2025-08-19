import 'package:json_annotation/json_annotation.dart';

part 'chapter_ahadiths_model.g.dart';

@JsonSerializable()
class HadithResponse {
  final int status;
  final Hadiths hadiths;

  HadithResponse({
    required this.status,
    required this.hadiths,
  });

  factory HadithResponse.fromJson(Map<String, dynamic> json) =>
      _$HadithResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HadithResponseToJson(this);
}

@JsonSerializable()
class Hadiths {
  final List<Hadith> data;

  Hadiths({required this.data});

  factory Hadiths.fromJson(Map<String, dynamic> json) =>
      _$HadithsFromJson(json);

  Map<String, dynamic> toJson() => _$HadithsToJson(this);
}

@JsonSerializable()
class Hadith {
  final int id;
  final int idInBook;
  final int chapterId;
  final int bookId;
  final String arabic;
  final HadithEnglish english;

  Hadith({
    required this.id,
    required this.idInBook,
    required this.chapterId,
    required this.bookId,
    required this.arabic,
    required this.english,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) =>
      _$HadithFromJson(json);

  Map<String, dynamic> toJson() => _$HadithToJson(this);
}

@JsonSerializable()
class HadithEnglish {
  final String narrator;
  final String text;

  HadithEnglish({
    required this.narrator,
    required this.text,
  });

  factory HadithEnglish.fromJson(Map<String, dynamic> json) =>
      _$HadithEnglishFromJson(json);

  Map<String, dynamic> toJson() => _$HadithEnglishToJson(this);
}

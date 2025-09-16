import 'package:json_annotation/json_annotation.dart';
part 'chapters_model.g.dart';

@JsonSerializable()
class ChaptersModel {
  final int? status;
  final List<Chapter>? chapters;

  const ChaptersModel({this.status, this.chapters});

  factory ChaptersModel.fromJson(Map<String, dynamic> json) =>
      _$ChaptersModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChaptersModelToJson(this);
}

@JsonSerializable()
class Chapter {
  @JsonKey(fromJson: _toInt)
  final int? chapterNumber;

  final String? chapterArabic;
  final String? chapterEnglish;
  final String? chapterUrdu;

  @JsonKey(name: 'hadiths_count', fromJson: _toInt)
  final int? hadithsCount;

  const Chapter({
    this.chapterNumber,
    this.chapterArabic,
    this.chapterEnglish,
    this.chapterUrdu,
    this.hadithsCount,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
    Map<String, dynamic> toJson() => _$ChapterToJson(this);

}
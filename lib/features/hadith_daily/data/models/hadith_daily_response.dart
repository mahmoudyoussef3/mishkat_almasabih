
import 'package:json_annotation/json_annotation.dart';
part 'hadith_daily_response.g.dart';
@JsonSerializable()
class DailyHadithModel {
  final bool? status;
  final HadithData? data;

  const DailyHadithModel({this.status, this.data});
  factory DailyHadithModel.fromJson(Map<String, dynamic> json) =>
      _$DailyHadithModelFromJson(json);
        Map<String,dynamic> toJson()=>_$DailyHadithModelToJson(this);

}
@JsonSerializable()
class HadithData {
  final String? title;
  final String? hadith;
  final String? attribution;
  final String? grade;
  final String? explanation;
  final List<String>? hints;


  @JsonKey(name: 'words_meanings') // مهم جدًا
  final List<WordMeaning>? wordsMeanings;

  const HadithData({
    this.title,
    this.hadith,
    this.attribution,
    this.grade,
    this.explanation,
    this.hints,
    this.wordsMeanings,
  });
  factory HadithData.fromJson(Map<String, dynamic> json) =>
      _$HadithDataFromJson(json);

             Map<String,dynamic> toJson()=>_$HadithDataToJson(this);
}

@JsonSerializable()
class WordMeaning {
  final String? word;
  final String? meaning;

  const WordMeaning({this.word, this.meaning});
  factory WordMeaning.fromJson(Map<String, dynamic> json) =>
      _$WordMeaningFromJson(json);

                   Map<String,dynamic> toJson()=>_$WordMeaningToJson(this);

}

import 'package:json_annotation/json_annotation.dart';
part 'new_daily_hadith_model.g.dart';



@JsonSerializable()
class NewDailyHadithModel {
  final String? title;
  final String? hadeeth;
  final String? attribution;
  final String? grade;
  final String? explanation;
  final List<String>? hints;
  final String? id;

  @JsonKey(name: 'words_meanings')
  final List<DailyHadithWordMeaning>? words_meanings;

  const NewDailyHadithModel({
    this.title,
    this.hadeeth,
    this.attribution,
    this.id,
    this.grade,
    this.explanation,
    this.hints,
    this.words_meanings,
  });
  factory NewDailyHadithModel.fromJson(Map<String, dynamic> json) =>
      _$NewDailyHadithModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewDailyHadithModelToJson(this);
}

@JsonSerializable()
class DailyHadithWordMeaning {
  final String? word;
  final String? meaning;

  const DailyHadithWordMeaning({this.word, this.meaning});
  factory DailyHadithWordMeaning.fromJson(Map<String, dynamic> json) =>
      _$DailyHadithWordMeaningFromJson(json);

  Map<String, dynamic> toJson() => _$DailyHadithWordMeaningToJson(this);
}

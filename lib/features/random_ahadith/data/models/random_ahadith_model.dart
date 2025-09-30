import 'package:json_annotation/json_annotation.dart';

part 'random_ahadith_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RandomAhadithResponse {
  final List<RandomHadithModel>? hadiths;

  RandomAhadithResponse({this.hadiths});

  factory RandomAhadithResponse.fromJson(Map<String, dynamic> json) =>
      _$RandomAhadithResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RandomAhadithResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RandomHadithModel {
  final String? hadithId;
  final String? hadith;
  final String? title;
  final String? attribution;
  final String? grade;
  final String? explanation;
  final List<String>? hints;
  final List<String>? categoriesIds;
  final List<RandomWordMeaning>? wordsMeanings;
  final String? reference;
  final String? language;
  final List<String>? categories;

  RandomHadithModel({
    this.hadithId,
    this.hadith,
    this.title,
    this.attribution,
    this.grade,
    this.explanation,
    this.hints,
    this.categoriesIds,
    this.wordsMeanings,
    this.reference,
    this.language,
    this.categories,
  });

  factory RandomHadithModel.fromJson(Map<String, dynamic> json) =>
      _$RandomHadithModelFromJson(json);

  Map<String, dynamic> toJson() => _$RandomHadithModelToJson(this);
}

@JsonSerializable()
class RandomWordMeaning {
  final String? word;
  final String? meaning;

  RandomWordMeaning({this.word, this.meaning});

  factory RandomWordMeaning.fromJson(Map<String, dynamic> json) =>
      _$RandomWordMeaningFromJson(json);

  Map<String, dynamic> toJson() => _$RandomWordMeaningToJson(this);
}

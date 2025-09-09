import 'package:json_annotation/json_annotation.dart';

part 'serag_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SeragRequestModel {
  final Hadith hadith;
  final List<Message> messages;

  SeragRequestModel({required this.hadith, required this.messages});

  factory SeragRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SeragRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SeragRequestModelToJson(this);
}

@JsonSerializable()
class Hadith {
  final String hadeeth;
  final String grade_ar;
  final String source;
  final String takhrij_ar;
  final String sharh;

  Hadith({
    required this.hadeeth,
    required this.grade_ar,
    required this.source,
    required this.sharh,
    required this.takhrij_ar,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);

  Map<String, dynamic> toJson() => _$HadithToJson(this);
}

@JsonSerializable()
class Message {
  final String role;
  final String content;

  Message({required this.role, required this.content});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

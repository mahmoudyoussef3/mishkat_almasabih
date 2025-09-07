import 'package:json_annotation/json_annotation.dart';

part 'serag_request_model.g.dart';

@JsonSerializable()
class SeragRequestModel {
  final String hadeeth;
  final String attribution;
  final String grade_ar;
  final String source;
  final String takhrig_ar;
  final String reference;

  // message لوحدها برّه
  final String message;

  SeragRequestModel({
    required this.hadeeth,
    required this.attribution,
    required this.grade_ar,
    required this.takhrig_ar,
    required this.source,
    required this.reference,
    required this.message,
  });

  factory SeragRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SeragRequestModelFromJson(json);

  Map<String, dynamic> toJson() => {
        "hadith": {
          "hadeeth": hadeeth,
          "attribution": attribution,
          "grade_ar": grade_ar,
          "source": source,
          "takhrig_ar": takhrig_ar,
          "reference": reference,
        },
        "message": message,
      };
}

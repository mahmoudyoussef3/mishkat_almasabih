import 'package:json_annotation/json_annotation.dart';

part 'hadith_analysis_request.g.dart';

@JsonSerializable()
class HadithAnalysisRequest {
  final String hadeeth;
  final String attribution;
  final String grade;
  final String reference;

  HadithAnalysisRequest({
    required this.hadeeth,
    required this.attribution,
    required this.grade,
    required this.reference,
  });

  Map<String, dynamic> toJson() => {
        "hadith": _$HadithAnalysisRequestToJson(this),
      };

  factory HadithAnalysisRequest.fromJson(Map<String, dynamic> json) =>
      _$HadithAnalysisRequestFromJson(json);
}

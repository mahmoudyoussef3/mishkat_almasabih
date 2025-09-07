import 'package:json_annotation/json_annotation.dart';

part 'hadith_analysis_response.g.dart';

@JsonSerializable()
class HadithAnalysisResponse {
  final String? hadith;
  final String? attribution;
  final String? analysis;
  final String? timestamp;

  HadithAnalysisResponse({
    this.hadith,
    this.attribution,
    this.analysis,
    this.timestamp,
  });

  factory HadithAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$HadithAnalysisResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HadithAnalysisResponseToJson(this);
}

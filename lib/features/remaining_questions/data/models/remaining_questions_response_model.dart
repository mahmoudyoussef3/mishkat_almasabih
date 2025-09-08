
import 'package:json_annotation/json_annotation.dart';

part 'remaining_questions_response_model.g.dart';

@JsonSerializable()
class RmainingQuestionsResponse {
  final int? remaining;
  final String? resetTime;
  final int? max;
  final int? currentCount;

  RmainingQuestionsResponse({
     this.remaining,
     this.resetTime,
     this.max,
     this.currentCount,
  });

  factory RmainingQuestionsResponse.fromJson(Map<String, dynamic> json) =>
      _$RmainingQuestionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RmainingQuestionsResponseToJson(this);
}

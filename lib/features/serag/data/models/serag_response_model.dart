import 'package:json_annotation/json_annotation.dart';
part 'serag_response_model.g.dart';
@JsonSerializable()
class SeragResponseModel {
  final String message;
  SeragResponseModel(this.message);
  factory SeragResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SeragResponseModelFromJson(json);
}

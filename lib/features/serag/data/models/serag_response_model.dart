import 'package:json_annotation/json_annotation.dart';

part 'serag_response_model.g.dart';

@JsonSerializable()
class SeragResponseModel {
  final String response;

  SeragResponseModel({required this.response});

  factory SeragResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SeragResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SeragResponseModelToJson(this);
}

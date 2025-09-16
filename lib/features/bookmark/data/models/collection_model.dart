import 'package:json_annotation/json_annotation.dart';

part 'collection_model.g.dart';

@JsonSerializable()
class CollectionsResponse {
  final List<CollectionItem>? collections;

  CollectionsResponse({this.collections});

  factory CollectionsResponse.fromJson(Map<String, dynamic> json) =>
      _$CollectionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionsResponseToJson(this);
}

@JsonSerializable()
class CollectionItem {
  final String? collection;
  final int? count;

  CollectionItem({this.collection, this.count});

  factory CollectionItem.fromJson(Map<String, dynamic> json) =>
      _$CollectionItemFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionItemToJson(this);
}
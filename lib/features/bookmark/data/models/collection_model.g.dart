// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionsResponse _$CollectionsResponseFromJson(Map<String, dynamic> json) =>
    CollectionsResponse(
      collections:
          (json['collections'] as List<dynamic>?)
              ?.map((e) => CollectionItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$CollectionsResponseToJson(
  CollectionsResponse instance,
) => <String, dynamic>{'collections': instance.collections};

CollectionItem _$CollectionItemFromJson(Map<String, dynamic> json) =>
    CollectionItem(
      collection: json['collection'] as String?,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CollectionItemToJson(CollectionItem instance) =>
    <String, dynamic>{
      'collection': instance.collection,
      'count': instance.count,
    };

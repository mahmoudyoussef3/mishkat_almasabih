// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  id: json['id'] as String,
  name: json['name'] as String,
  nameEn: json['nameEn'] as String,
  nameUr: json['nameUr'] as String,
  description: json['description'] as String,
  descriptionEn: json['descriptionEn'] as String,
  descriptionUr: json['descriptionUr'] as String,
  books:
      (json['books'] as List<dynamic>)
          .map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'nameEn': instance.nameEn,
  'nameUr': instance.nameUr,
  'description': instance.description,
  'descriptionEn': instance.descriptionEn,
  'descriptionUr': instance.descriptionUr,
  'books': instance.books,
};

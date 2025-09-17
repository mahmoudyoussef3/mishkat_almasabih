import 'package:json_annotation/json_annotation.dart';

import 'package:mishkat_almasabih/features/home/data/models/book_model.dart';

part 'category_model.g.dart';
@JsonSerializable()
class Category {
  final String id;
  final String name;
  final String nameEn;
  final String nameUr;
  final String description;
  final String descriptionEn;
  final String descriptionUr;
  final List<Book> books;

  Category({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.nameUr,
    required this.description,
    required this.descriptionEn,
    required this.descriptionUr,
    required this.books,
  });
        factory Category.fromJson(Map<String,dynamic> json)=>_$CategoryFromJson(json);

}
import 'package:json_annotation/json_annotation.dart';

import 'category_model.dart';
part 'book_model.g.dart';
@JsonSerializable()
class BooksResponse {
  final int status;
  final Map<String, Category> categories;
  final List<Book> allBooks;

  BooksResponse({
    required this.status,
    required this.categories,
    required this.allBooks,
  });
      factory BooksResponse.fromJson(Map<String,dynamic> json)=>_$BooksResponseFromJson(json);

}
@JsonSerializable()
class Book {
  final int id;
  final String bookName;
  final String? bookNameEn;
  final String? bookNameUr;
  final String writerName;
  final String? writerNameEn;
  final String? writerNameUr;
  final String? aboutWriter;
  final String? writerDeath;
  final String bookSlug;
  final String hadithsCount;
  final String chaptersCount;
  final String? status;
  final bool? isLocal;
  final String? category;
  final String? filePath;

  Book({
    required this.id,
    required this.bookName,
    this.bookNameEn,
    this.bookNameUr,
    required this.writerName,
    this.writerNameEn,
    this.writerNameUr,
    this.aboutWriter,
    this.writerDeath,
    required this.bookSlug,
    required this.hadithsCount,
    required this.chaptersCount,
    this.status,
    this.isLocal,
    this.category,
    this.filePath,
  });




    factory Book.fromJson(Map<String,dynamic> json)=>_$BookFromJson(json);

}

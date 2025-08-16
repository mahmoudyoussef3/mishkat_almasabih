// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BooksResponse _$BooksResponseFromJson(Map<String, dynamic> json) =>
    BooksResponse(
      status: (json['status'] as num).toInt(),
      categories: (json['categories'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Category.fromJson(e as Map<String, dynamic>)),
      ),
      allBooks:
          (json['allBooks'] as List<dynamic>)
              .map((e) => Book.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$BooksResponseToJson(BooksResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'categories': instance.categories,
      'allBooks': instance.allBooks,
    };

Book _$BookFromJson(Map<String, dynamic> json) => Book(
  id: (json['id'] as num).toInt(),
  bookName: json['bookName'] as String,
  bookNameEn: json['bookNameEn'] as String?,
  bookNameUr: json['bookNameUr'] as String?,
  writerName: json['writerName'] as String,
  writerNameEn: json['writerNameEn'] as String?,
  writerNameUr: json['writerNameUr'] as String?,
  aboutWriter: json['aboutWriter'] as String?,
  writerDeath: json['writerDeath'] as String?,
  bookSlug: json['bookSlug'] as String,
  hadithsCount: json['hadithsCount'] as String,
  chaptersCount: json['chaptersCount'] as String,
  status: json['status'] as String?,
  isLocal: json['isLocal'] as bool?,
  category: json['category'] as String?,
  filePath: json['filePath'] as String?,
);

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
  'id': instance.id,
  'bookName': instance.bookName,
  'bookNameEn': instance.bookNameEn,
  'bookNameUr': instance.bookNameUr,
  'writerName': instance.writerName,
  'writerNameEn': instance.writerNameEn,
  'writerNameUr': instance.writerNameUr,
  'aboutWriter': instance.aboutWriter,
  'writerDeath': instance.writerDeath,
  'bookSlug': instance.bookSlug,
  'hadithsCount': instance.hadithsCount,
  'chaptersCount': instance.chaptersCount,
  'status': instance.status,
  'isLocal': instance.isLocal,
  'category': instance.category,
  'filePath': instance.filePath,
};

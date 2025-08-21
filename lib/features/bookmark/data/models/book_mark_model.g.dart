// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_mark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarksResponse _$BookmarksResponseFromJson(Map<String, dynamic> json) =>
    BookmarksResponse(
      bookmarks:
          (json['bookmarks'] as List<dynamic>?)
              ?.map((e) => Bookmark.fromJson(e as Map<String, dynamic>))
              .toList(),
      pagination:
          json['pagination'] == null
              ? null
              : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookmarksResponseToJson(BookmarksResponse instance) =>
    <String, dynamic>{
      'bookmarks': instance.bookmarks,
      'pagination': instance.pagination,
    };

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => Bookmark(
  id: (json['id'] as num?)?.toInt(),
  user_id: (json['user_id'] as num?)?.toInt(),
  type: json['type'] as String?,
  book_slug: json['book_slug'] as String?,
  book_name: json['book_name'] as String?,
  book_name_en: json['book_name_en'] as String?,
  book_name_ur: json['book_name_ur'] as String?,
  chapter_number: (json['chapter_number'] as num?)?.toInt(),
  chapter_name: json['chapter_name'] as String?,
  chapter_name_en: json['chapter_name_en'] as String?,
  chapter_name_ur: json['chapter_name_ur'] as String?,
  hadith_id: json['hadith_id'] as String?,
  hadith_number: json['hadith_number'] as String?,
  hadith_text: json['hadith_text'] as String?,
  hadith_text_en: json['hadith_text_en'] as String?,
  hadith_text_ur: json['hadith_text_ur'] as String?,
  collection: json['collection'] as String?,
  notes: json['notes'] as String?,
  is_local: (json['is_local'] as num?)?.toInt(),
  created_at: json['created_at'] as String?,
  updated_at: json['updated_at'] as String?,
);

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.user_id,
  'type': instance.type,
  'book_slug': instance.book_slug,
  'book_name': instance.book_name,
  'book_name_en': instance.book_name_en,
  'book_name_ur': instance.book_name_ur,
  'chapter_number': instance.chapter_number,
  'chapter_name': instance.chapter_name,
  'chapter_name_en': instance.chapter_name_en,
  'chapter_name_ur': instance.chapter_name_ur,
  'hadith_id': instance.hadith_id,
  'hadith_number': instance.hadith_number,
  'hadith_text': instance.hadith_text,
  'hadith_text_en': instance.hadith_text_en,
  'hadith_text_ur': instance.hadith_text_ur,
  'collection': instance.collection,
  'notes': instance.notes,
  'is_local': instance.is_local,
  'created_at': instance.created_at,
  'updated_at': instance.updated_at,
};

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  current_page: (json['current_page'] as num?)?.toInt(),
  total_pages: (json['total_pages'] as num?)?.toInt(),
  total_items: (json['total_items'] as num?)?.toInt(),
  items_per_page: (json['items_per_page'] as num?)?.toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'current_page': instance.current_page,
      'total_pages': instance.total_pages,
      'total_items': instance.total_items,
      'items_per_page': instance.items_per_page,
    };

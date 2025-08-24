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
  userId: (json['user_id'] as num?)?.toInt(),
  type: json['type'] as String?,
  bookSlug: json['bookSlug'] as String?,
  bookName: json['book_name'] as String?,
  chapterName: json['chapter_name'] as String?,
  hadithId: json['hadith_id'] as String?,
  hadithNumber: json['hadith_number'] as String?,
  hadithText: json['hadith_text'] as String?,
  collection: json['collection'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'type': instance.type,
  'bookSlug': instance.bookSlug,
  'book_name': instance.bookName,
  'chapter_name': instance.chapterName,
  'hadith_id': instance.hadithId,
  'hadith_number': instance.hadithNumber,
  'hadith_text': instance.hadithText,
  'collection': instance.collection,
  'notes': instance.notes,
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

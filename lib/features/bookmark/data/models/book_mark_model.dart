import 'package:json_annotation/json_annotation.dart';

part 'book_mark_model.g.dart';

@JsonSerializable()
class BookmarksResponse {
  final List<Bookmark>? bookmarks;
  final Pagination? pagination;

  BookmarksResponse({this.bookmarks, this.pagination});
  factory BookmarksResponse.fromJson(Map<String, dynamic> json) =>
      _$BookmarksResponseFromJson(json);
}

@JsonSerializable()
class Bookmark {
  final int? id;
  final int? user_id;
  final String? type;
  final String? book_slug;
  final String? book_name;
  final String? book_name_en;
  final String? book_name_ur;
  final int? chapter_number;
  final String? chapter_name;
  final String? chapter_name_en;
  final String? chapter_name_ur;
  final String? hadith_id;
  final String? hadith_number;
  final String? hadith_text;
  final String? hadith_text_en;
  final String? hadith_text_ur;
  final String? collection;
  final String? notes;
  final int? is_local;
  final String? created_at;
  final String? updated_at;

  Bookmark({
    this.id,
    this.user_id,
    this.type,
    this.book_slug,
    this.book_name,
    this.book_name_en,
    this.book_name_ur,
    this.chapter_number,
    this.chapter_name,
    this.chapter_name_en,
    this.chapter_name_ur,
    this.hadith_id,
    this.hadith_number,
    this.hadith_text,
    this.hadith_text_en,
    this.hadith_text_ur,
    this.collection,
    this.notes,
    this.is_local,
    this.created_at,
    this.updated_at,
  });
    Map<String, dynamic> toJson() => _$BookmarkToJson(this);
  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);

}

@JsonSerializable()
class Pagination {
  final int? current_page;
  final int? total_pages;
  final int? total_items;
  final int? items_per_page;

  Pagination({
    this.current_page,
    this.total_pages,
    this.total_items,
    this.items_per_page,
  });
    factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
}

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

  @JsonKey(name: 'user_id')
  final int? userId;

  final String? type;

  final String? bookSlug;

  @JsonKey(name: 'book_name')
  final String? bookName;

  @JsonKey(name: 'chapter_name')
  final String? chapterName;

  @JsonKey(name: 'hadith_id')
  final String? hadithId;

  @JsonKey(name: 'hadith_number')
  final String? hadithNumber;

  @JsonKey(name: 'hadith_text')
  final String? hadithText;

  final String? collection;
  final String? notes;

  Bookmark({
    this.id,
    this.userId,
    this.type,
    this.bookSlug,
    this.bookName,
    this.chapterName,
    this.hadithId,
    this.hadithNumber,
    this.hadithText,
    this.collection,
    this.notes,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkToJson(this);
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

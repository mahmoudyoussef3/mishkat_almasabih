class BookmarksResponse {
  final List<Bookmark>? bookmarks;
  final Pagination? pagination;

  BookmarksResponse({this.bookmarks, this.pagination});

  factory BookmarksResponse.fromJson(Map<String, dynamic> json) {
    return BookmarksResponse(
      bookmarks:
          (json['bookmarks'] as List<dynamic>?)
              ?.map((e) => Bookmark.fromJson(e as Map<String, dynamic>))
              .toList(),
      pagination:
          json['pagination'] != null
              ? Pagination.fromJson(json['pagination'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookmarks': bookmarks?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class Bookmark {
  final int? id;
  final int? userId;
  final String? type;
  final String? bookSlug;
  final String? bookName;
  final String? bookNameEn;
  final String? bookNameUr;
  final int? chapterNumber;
  final String? chapterName;
  final String? chapterNameEn;
  final String? chapterNameUr;
  final String? hadithId;
  final String? hadithNumber;
  final String? hadithText;
  final String? hadithTextEn;
  final String? hadithTextUr;
  final String? collection;
  final String? notes;
  final int? isLocal;
  final String? createdAt;
  final String? updatedAt;

  Bookmark({
    this.id,
    this.userId,
    this.type,
    this.bookSlug,
    this.bookName,
    this.bookNameEn,
    this.bookNameUr,
    this.chapterNumber,
    this.chapterName,
    this.chapterNameEn,
    this.chapterNameUr,
    this.hadithId,
    this.hadithNumber,
    this.hadithText,
    this.hadithTextEn,
    this.hadithTextUr,
    this.collection,
    this.notes,
    this.isLocal,
    this.createdAt,
    this.updatedAt,
  });

  /// fromJson => بياخد snake_case (اللي جاي من السيرفر)
  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      type: json['type'] as String?,
      bookSlug: json['bookSlug'] as String?,
      bookName: json['book_name'] as String?,
      bookNameEn: json['book_name_en'] as String?,
      bookNameUr: json['book_name_ur'] as String?,
      chapterNumber: json['chapter_number'] as int?,
      chapterName: json['chapter_name'] as String?,
      chapterNameEn: json['chapter_name_en'] as String?,
      chapterNameUr: json['chapter_name_ur'] as String?,
      hadithId: json['hadith_id'] as String?,
      hadithNumber: json['hadith_number'] as String?,
      hadithText: json['hadith_text'] as String?,
      hadithTextEn: json['hadith_text_en'] as String?,
      hadithTextUr: json['hadith_text_ur'] as String?,
      collection: json['collection'] as String?,
      notes: json['notes'] as String?,
      isLocal: json['is_local'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  /// toJson => بيبعت camelCase (زي الريكويست اللي محتاجه الـ API)
  // داخل Bookmark class
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'bookSlug': bookSlug,
      'book_name': bookName,
      'book_name_en': bookNameEn,
      'book_name_ur': bookNameUr,
      'chapter_number': chapterNumber,
      'chapter_name': chapterName,
      'chapter_name_en': chapterNameEn,
      'chapter_name_ur': chapterNameUr,
      'hadith_id': hadithId,
      'hadith_number': hadithNumber,
      'hadith_text': hadithText,
      'hadith_text_en': hadithTextEn,
      'hadith_text_ur': hadithTextUr,
      'collection': collection,
      'notes': notes,
      'is_local': isLocal,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Pagination {
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final int? itemsPerPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] as int?,
      totalPages: json['total_pages'] as int?,
      totalItems: json['total_items'] as int?,
      itemsPerPage: json['items_per_page'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_items': totalItems,
      'items_per_page': itemsPerPage,
    };
  }
}
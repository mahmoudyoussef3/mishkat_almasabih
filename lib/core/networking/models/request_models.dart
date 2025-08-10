/// Request Models for API Service
/// Contains all request data models used in API calls

/// Login request model
class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;

  LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'remember_me': rememberMe,
  };
}

/// Register request model
class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'password_confirmation': passwordConfirmation,
  };
}

/// Refresh token request model
class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {
    'refresh_token': refreshToken,
  };
}

/// Update profile request model
class UpdateProfileRequest {
  final String? name;
  final String? email;
  final String? avatar;

  UpdateProfileRequest({
    this.name,
    this.email,
    this.avatar,
  });

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (email != null) 'email': email,
    if (avatar != null) 'avatar': avatar,
  };
}

/// Change password request model
class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    'current_password': currentPassword,
    'new_password': newPassword,
    'new_password_confirmation': newPasswordConfirmation,
  };
}

/// Add bookmark request model
class AddBookmarkRequest {
  final String itemId;
  final String itemType; // 'hadith' or 'book'
  final String? note;

  AddBookmarkRequest({
    required this.itemId,
    required this.itemType,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    'item_id': itemId,
    'item_type': itemType,
    if (note != null) 'note': note,
  };
}

/// Remove bookmark request model
class RemoveBookmarkRequest {
  final String bookmarkId;

  RemoveBookmarkRequest({required this.bookmarkId});

  Map<String, dynamic> toJson() => {
    'bookmark_id': bookmarkId,
  };
}

/// Update progress request model
class UpdateProgressRequest {
  final String itemId;
  final String itemType; // 'hadith' or 'book'
  final int progress; // 0-100
  final String? location; // page number, verse number, etc.

  UpdateProgressRequest({
    required this.itemId,
    required this.itemType,
    required this.progress,
    this.location,
  });

  Map<String, dynamic> toJson() => {
    'item_id': itemId,
    'item_type': itemType,
    'progress': progress,
    if (location != null) 'location': location,
  };
}

/// Mark as read request model
class MarkAsReadRequest {
  final List<String> notificationIds;

  MarkAsReadRequest({required this.notificationIds});

  Map<String, dynamic> toJson() => {
    'notification_ids': notificationIds,
  };
}

/// Feedback request model
class FeedbackRequest {
  final String type; // 'bug', 'feature', 'general'
  final String message;
  final String? email;
  final String? deviceInfo;

  FeedbackRequest({
    required this.type,
    required this.message,
    this.email,
    this.deviceInfo,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'message': message,
    if (email != null) 'email': email,
    if (deviceInfo != null) 'device_info': deviceInfo,
  };
}

/// Search request model for hadith and books
class SearchRequest {
  final String query;
  final String? category;
  final String? book;
  final String? narrator;
  final int? page;
  final int? limit;
  final String? sortBy; // 'relevance', 'date', 'popularity'
  final String? language; // 'ar', 'en', 'ur', etc.

  SearchRequest({
    required this.query,
    this.category,
    this.book,
    this.narrator,
    this.page,
    this.limit = 20,
    this.sortBy = 'relevance',
    this.language,
  });

  Map<String, dynamic> toJson() => {
    'query': query,
    if (category != null) 'category': category,
    if (book != null) 'book': book,
    if (narrator != null) 'narrator': narrator,
    if (page != null) 'page': page,
    'limit': limit,
    'sort_by': sortBy,
    if (language != null) 'language': language,
  };
}

/// Filter request model for advanced search
class FilterRequest {
  final List<String>? categories;
  final List<String>? books;
  final List<String>? narrators;
  final String? authenticity; // 'sahih', 'hasan', 'daif'
  final String? grade; // 'mutawatir', 'ahad', etc.
  final String? topic;
  final String? language;
  final int? minLength; // minimum number of words
  final int? maxLength; // maximum number of words

  FilterRequest({
    this.categories,
    this.books,
    this.narrators,
    this.authenticity,
    this.grade,
    this.topic,
    this.language,
    this.minLength,
    this.maxLength,
  });

  Map<String, dynamic> toJson() => {
    if (categories != null) 'categories': categories,
    if (books != null) 'books': books,
    if (narrators != null) 'narrators': narrators,
    if (authenticity != null) 'authenticity': authenticity,
    if (grade != null) 'grade': grade,
    if (topic != null) 'topic': topic,
    if (language != null) 'language': language,
    if (minLength != null) 'min_length': minLength,
    if (maxLength != null) 'max_length': maxLength,
  };
}

/// Get hadith request model
class GetHadithRequest {
  final String hadithId;
  final String? language;
  final bool includeTranslation;
  final bool includeCommentary;
  final bool includeReferences;

  GetHadithRequest({
    required this.hadithId,
    this.language,
    this.includeTranslation = true,
    this.includeCommentary = false,
    this.includeReferences = false,
  });

  Map<String, dynamic> toJson() => {
    'hadith_id': hadithId,
    if (language != null) 'language': language,
    'include_translation': includeTranslation,
    'include_commentary': includeCommentary,
    'include_references': includeReferences,
  };
}

/// Get book request model
class GetBookRequest {
  final String bookId;
  final String? language;
  final bool includeChapters;
  final bool includeMetadata;

  GetBookRequest({
    required this.bookId,
    this.language,
    this.includeChapters = true,
    this.includeMetadata = true,
  });

  Map<String, dynamic> toJson() => {
    'book_id': bookId,
    if (language != null) 'language': language,
    'include_chapters': includeChapters,
    'include_metadata': includeMetadata,
  };
}

/// Get chapter request model
class GetChapterRequest {
  final String chapterId;
  final String? language;
  final int? page;
  final int? limit;

  GetChapterRequest({
    required this.chapterId,
    this.language,
    this.page,
    this.limit = 50,
  });

  Map<String, dynamic> toJson() => {
    'chapter_id': chapterId,
    if (language != null) 'language': language,
    if (page != null) 'page': page,
    'limit': limit,
  };
}

/// Rate content request model
class RateContentRequest {
  final String itemId;
  final String itemType; // 'hadith', 'book', 'chapter'
  final int rating; // 1-5
  final String? comment;

  RateContentRequest({
    required this.itemId,
    required this.itemType,
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() => {
    'item_id': itemId,
    'item_type': itemType,
    'rating': rating,
    if (comment != null) 'comment': comment,
  };
}

/// Share content request model
class ShareContentRequest {
  final String itemId;
  final String itemType;
  final String platform; // 'whatsapp', 'telegram', 'email', 'copy'
  final String? message;
  final String? language;

  ShareContentRequest({
    required this.itemId,
    required this.itemType,
    required this.platform,
    this.message,
    this.language,
  });

  Map<String, dynamic> toJson() => {
    'item_id': itemId,
    'item_type': itemType,
    'platform': platform,
    if (message != null) 'message': message,
    if (language != null) 'language': language,
  };
}

/// Download content request model
class DownloadContentRequest {
  final String itemId;
  final String itemType;
  final String format; // 'pdf', 'epub', 'txt'
  final String? language;
  final bool includeMetadata;

  DownloadContentRequest({
    required this.itemId,
    required this.itemType,
    required this.format,
    this.language,
    this.includeMetadata = true,
  });

  Map<String, dynamic> toJson() => {
    'item_id': itemId,
    'item_type': itemType,
    'format': format,
    if (language != null) 'language': language,
    'include_metadata': includeMetadata,
  };
}

/// Get daily hadith request model
class GetDailyHadithRequest {
  final String? language;
  final String? category;
  final String? date; // YYYY-MM-DD format

  GetDailyHadithRequest({
    this.language,
    this.category,
    this.date,
  });

  Map<String, dynamic> toJson() => {
    if (language != null) 'language': language,
    if (category != null) 'category': category,
    if (date != null) 'date': date,
  };
}

/// Get random hadith request model
class GetRandomHadithRequest {
  final String? language;
  final String? category;
  final String? book;
  final String? narrator;

  GetRandomHadithRequest({
    this.language,
    this.category,
    this.book,
    this.narrator,
  });

  Map<String, dynamic> toJson() => {
    if (language != null) 'language': language,
    if (category != null) 'category': category,
    if (book != null) 'book': book,
    if (narrator != null) 'narrator': narrator,
  };
}

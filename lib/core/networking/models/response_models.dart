/// Response Models for API Service
/// Contains all response data models used in API calls

/// Generic paginated response wrapper
class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMorePages;

  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMorePages,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      data: (json['data'] as List).map((item) => fromJsonT(item)).toList(),
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 20,
      total: json['total'] ?? 0,
      hasMorePages: json['has_more_pages'] ?? false,
    );
  }
}

/// Login response model
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserProfile user;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      user: UserProfile.fromJson(json['user']),
    );
  }
}

/// Register response model
class RegisterResponse {
  final String message;
  final UserProfile user;

  RegisterResponse({required this.message, required this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'],
      user: UserProfile.fromJson(json['user']),
    );
  }
}

/// Refresh token response model
class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  RefreshTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }
}

/// User profile model
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Hadith model
class Hadith {
  final String id;
  final String text;
  final String arabicText;
  final String narrator;
  final String book;
  final String category;
  final int hadithNumber;
  final String? grade;
  final String? explanation;
  final DateTime createdAt;

  Hadith({
    required this.id,
    required this.text,
    required this.arabicText,
    required this.narrator,
    required this.book,
    required this.category,
    required this.hadithNumber,
    this.grade,
    this.explanation,
    required this.createdAt,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'],
      text: json['text'],
      arabicText: json['arabic_text'],
      narrator: json['narrator'],
      book: json['book'],
      category: json['category'],
      hadithNumber: json['hadith_number'],
      grade: json['grade'],
      explanation: json['explanation'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

/// Daily hadith model
class DailyHadith {
  final Hadith hadith;
  final DateTime date;
  final String? reflection;

  DailyHadith({required this.hadith, required this.date, this.reflection});

  factory DailyHadith.fromJson(Map<String, dynamic> json) {
    return DailyHadith(
      hadith: Hadith.fromJson(json['hadith']),
      date: DateTime.parse(json['date']),
      reflection: json['reflection'],
    );
  }
}

/// Book model
class Book {
  final String id;
  final String title;
  final String arabicTitle;
  final String author;
  final String category;
  final String description;
  final String? coverImage;
  final int totalChapters;
  final int totalPages;
  final DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.author,
    required this.category,
    required this.description,
    this.coverImage,
    required this.totalChapters,
    required this.totalPages,
    required this.createdAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      arabicTitle: json['arabic_title'],
      author: json['author'],
      category: json['category'],
      description: json['description'],
      coverImage: json['cover_image'],
      totalChapters: json['total_chapters'],
      totalPages: json['total_pages'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

/// Chapter model
class Chapter {
  final String id;
  final String title;
  final String arabicTitle;
  final int chapterNumber;
  final int pageNumber;
  final String? summary;

  Chapter({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.chapterNumber,
    required this.pageNumber,
    this.summary,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      title: json['title'],
      arabicTitle: json['arabic_title'],
      chapterNumber: json['chapter_number'],
      pageNumber: json['page_number'],
      summary: json['summary'],
    );
  }
}

/// Book content model
class BookContent {
  final String id;
  final String title;
  final List<Chapter> chapters;
  final String content;
  final DateTime lastUpdated;

  BookContent({
    required this.id,
    required this.title,
    required this.chapters,
    required this.content,
    required this.lastUpdated,
  });

  factory BookContent.fromJson(Map<String, dynamic> json) {
    return BookContent(
      id: json['id'],
      title: json['title'],
      chapters:
          (json['chapters'] as List).map((c) => Chapter.fromJson(c)).toList(),
      content: json['content'],
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }
}

/// Category model
class Category {
  final String id;
  final String name;
  final String arabicName;
  final String description;
  final String? icon;
  final int totalBooks;
  final int totalHadith;

  Category({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.description,
    this.icon,
    required this.totalBooks,
    required this.totalHadith,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      arabicName: json['arabic_name'],
      description: json['description'],
      icon: json['icon'],
      totalBooks: json['total_books'],
      totalHadith: json['total_hadith'],
    );
  }
}

/// Author model
class Author {
  final String id;
  final String name;
  final String arabicName;
  final String biography;
  final String? portrait;
  final int totalBooks;
  final DateTime? birthDate;
  final DateTime? deathDate;

  Author({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.biography,
    this.portrait,
    required this.totalBooks,
    this.birthDate,
    this.deathDate,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      arabicName: json['arabic_name'],
      biography: json['biography'],
      portrait: json['portrait'],
      totalBooks: json['total_books'],
      birthDate:
          json['birth_date'] != null
              ? DateTime.parse(json['birth_date'])
              : null,
      deathDate:
          json['death_date'] != null
              ? DateTime.parse(json['death_date'])
              : null,
    );
  }
}

/// Narrator model
class Narrator {
  final String id;
  final String name;
  final String arabicName;
  final String biography;
  final String? portrait;
  final int totalHadith;
  final String? reliability;

  Narrator({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.biography,
    this.portrait,
    required this.totalHadith,
    this.reliability,
  });

  factory Narrator.fromJson(Map<String, dynamic> json) {
    return Narrator(
      id: json['id'],
      name: json['name'],
      arabicName: json['arabic_name'],
      biography: json['biography'],
      portrait: json['portrait'],
      totalHadith: json['total_hadith'],
      reliability: json['reliability'],
    );
  }
}

/// Global search response model
class GlobalSearchResponse {
  final List<Hadith> hadith;
  final List<Book> books;
  final List<Author> authors;
  final List<Narrator> narrators;
  final int totalResults;

  GlobalSearchResponse({
    required this.hadith,
    required this.books,
    required this.authors,
    required this.narrators,
    required this.totalResults,
  });

  factory GlobalSearchResponse.fromJson(Map<String, dynamic> json) {
    return GlobalSearchResponse(
      hadith: (json['hadith'] as List).map((h) => Hadith.fromJson(h)).toList(),
      books: (json['books'] as List).map((b) => Book.fromJson(b)).toList(),
      authors:
          (json['authors'] as List).map((a) => Author.fromJson(a)).toList(),
      narrators:
          (json['narrators'] as List).map((n) => Narrator.fromJson(n)).toList(),
      totalResults: json['total_results'],
    );
  }
}

/// Search history item model
class SearchHistoryItem {
  final String id;
  final String query;
  final DateTime searchedAt;
  final int resultCount;

  SearchHistoryItem({
    required this.id,
    required this.query,
    required this.searchedAt,
    required this.resultCount,
  });

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      id: json['id'],
      query: json['query'],
      searchedAt: DateTime.parse(json['searched_at']),
      resultCount: json['result_count'],
    );
  }
}

/// Bookmark model
class Bookmark {
  final String id;
  final String itemId;
  final String itemType;
  final String itemTitle;
  final String? note;
  final DateTime createdAt;

  Bookmark({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.itemTitle,
    this.note,
    required this.createdAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      itemId: json['item_id'],
      itemType: json['item_type'],
      itemTitle: json['item_title'],
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

/// Reading progress model
class ReadingProgress {
  final String id;
  final String itemId;
  final String itemType;
  final int progress;
  final String? location;
  final DateTime lastRead;
  final DateTime updatedAt;

  ReadingProgress({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.progress,
    this.location,
    required this.lastRead,
    required this.updatedAt,
  });

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      id: json['id'],
      itemId: json['item_id'],
      itemType: json['item_type'],
      progress: json['progress'],
      location: json['location'],
      lastRead: DateTime.parse(json['last_read']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Reading history item model
class ReadingHistoryItem {
  final String id;
  final String itemId;
  final String itemType;
  final String itemTitle;
  final int progress;
  final DateTime lastRead;

  ReadingHistoryItem({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.itemTitle,
    required this.progress,
    required this.lastRead,
  });

  factory ReadingHistoryItem.fromJson(Map<String, dynamic> json) {
    return ReadingHistoryItem(
      id: json['id'],
      itemId: json['item_id'],
      itemType: json['item_type'],
      itemTitle: json['item_title'],
      progress: json['progress'],
      lastRead: DateTime.parse(json['last_read']),
    );
  }
}

/// Notification model
class Notification {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
      data: json['data'],
    );
  }
}

/// Notification settings model
class NotificationSettings {
  final bool pushEnabled;
  final bool emailEnabled;
  final bool dailyHadith;
  final bool newBooks;
  final bool updates;

  NotificationSettings({
    required this.pushEnabled,
    required this.emailEnabled,
    required this.dailyHadith,
    required this.newBooks,
    required this.updates,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      pushEnabled: json['push_enabled'],
      emailEnabled: json['email_enabled'],
      dailyHadith: json['daily_hadith'],
      newBooks: json['new_books'],
      updates: json['updates'],
    );
  }

  Map<String, dynamic> toJson() => {
    'push_enabled': pushEnabled,
    'email_enabled': emailEnabled,
    'daily_hadith': dailyHadith,
    'new_books': newBooks,
    'updates': updates,
  };
}

/// Quran verse model
class QuranVerse {
  final String id;
  final int surahNumber;
  final String surahName;
  final String arabicSurahName;
  final int ayahNumber;
  final String text;
  final String arabicText;
  final String translation;
  final int pageNumber;
  final int juzNumber;

  QuranVerse({
    required this.id,
    required this.surahNumber,
    required this.surahName,
    required this.arabicSurahName,
    required this.ayahNumber,
    required this.text,
    required this.arabicText,
    required this.translation,
    required this.pageNumber,
    required this.juzNumber,
  });

  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    return QuranVerse(
      id: json['id'],
      surahNumber: json['surah_number'],
      surahName: json['surah_name'],
      arabicSurahName: json['arabic_surah_name'],
      ayahNumber: json['ayah_number'],
      text: json['text'],
      arabicText: json['arabic_text'],
      translation: json['translation'],
      pageNumber: json['page_number'],
      juzNumber: json['juz_number'],
    );
  }
}

/// Quran surah model
class QuranSurah {
  final int number;
  final String name;
  final String arabicName;
  final String englishName;
  final String revelationType;
  final int totalAyahs;
  final String description;

  QuranSurah({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.englishName,
    required this.revelationType,
    required this.totalAyahs,
    required this.description,
  });

  factory QuranSurah.fromJson(Map<String, dynamic> json) {
    return QuranSurah(
      number: json['number'],
      name: json['name'],
      arabicName: json['arabic_name'],
      englishName: json['english_name'],
      revelationType: json['revelation_type'],
      totalAyahs: json['total_ayahs'],
      description: json['description'],
    );
  }
}

/// App version model
class AppVersion {
  final String version;
  final String buildNumber;
  final String platform;
  final bool isLatest;
  final String? downloadUrl;
  final String? releaseNotes;

  AppVersion({
    required this.version,
    required this.buildNumber,
    required this.platform,
    required this.isLatest,
    this.downloadUrl,
    this.releaseNotes,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      version: json['version'],
      buildNumber: json['build_number'],
      platform: json['platform'],
      isLatest: json['is_latest'],
      downloadUrl: json['download_url'],
      releaseNotes: json['release_notes'],
    );
  }
}

/// App settings model
class AppSettings {
  final String language;
  final String theme;
  final bool autoPlayAudio;
  final bool showArabicText;
  final bool showTranslation;
  final String fontSize;

  AppSettings({
    required this.language,
    required this.theme,
    required this.autoPlayAudio,
    required this.showArabicText,
    required this.showTranslation,
    required this.fontSize,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      language: json['language'],
      theme: json['theme'],
      autoPlayAudio: json['auto_play_audio'],
      showArabicText: json['show_arabic_text'],
      showTranslation: json['show_translation'],
      fontSize: json['font_size'],
    );
  }

  Map<String, dynamic> toJson() => {
    'language': language,
    'theme': theme,
    'auto_play_audio': autoPlayAudio,
    'show_arabic_text': showArabicText,
    'show_translation': showTranslation,
    'font_size': fontSize,
  };
}

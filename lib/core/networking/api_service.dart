import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'api_constants.dart';
import 'models/request_models.dart';
import 'models/response_models.dart';

// This file will be generated using build_runner
part 'api_service.g.dart';

/// API Service for Mishkat Al-Masabih Islamic Library App
/// Contains all API endpoints using Retrofit annotations
@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  // ==================== AUTHENTICATION ENDPOINTS ====================

  /// User login
  @POST(ApiConstants.login)
  Future<HttpResponse<LoginResponse>> login(@Body() LoginRequest request);

  /// User registration
  @POST(ApiConstants.register)
  Future<HttpResponse<RegisterResponse>> register(
    @Body() RegisterRequest request,
  );

  /// Refresh authentication token
  @POST(ApiConstants.refreshToken)
  Future<HttpResponse<RefreshTokenResponse>> refreshToken(
    @Body() RefreshTokenRequest request,
  );

  /// User logout
  @POST(ApiConstants.logout)
  Future<HttpResponse<void>> logout();

  // ==================== USER MANAGEMENT ENDPOINTS ====================

  /// Get user profile
  @GET(ApiConstants.userProfile)
  Future<HttpResponse<UserProfile>> getUserProfile();

  /// Update user profile
  @PUT(ApiConstants.updateProfile)
  Future<HttpResponse<UserProfile>> updateProfile(
    @Body() UpdateProfileRequest request,
  );

  /// Change user password
  @POST(ApiConstants.changePassword)
  Future<HttpResponse<void>> changePassword(
    @Body() ChangePasswordRequest request,
  );

  // ==================== HADITH ENDPOINTS ====================

  /// Get list of hadith with pagination and filters
  @GET(ApiConstants.hadithList)
  Future<HttpResponse<PaginatedResponse<Hadith>>> getHadithList({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('category') String? category,
    @Query('book') String? book,
    @Query('narrator') String? narrator,
    @Query('search') String? search,
    @Query('sort') String? sort,
  });

  /// Get specific hadith by ID
  @GET(ApiConstants.hadithDetail)
  Future<HttpResponse<Hadith>> getHadithDetail(@Path('id') String id);

  /// Search hadith
  @GET(ApiConstants.hadithSearch)
  Future<HttpResponse<PaginatedResponse<Hadith>>> searchHadith({
    @Query('q') required String query,
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('category') String? category,
    @Query('book') String? book,
  });

  /// Get hadith by category
  @GET(ApiConstants.hadithByCategory)
  Future<HttpResponse<PaginatedResponse<Hadith>>> getHadithByCategory({
    @Path('categoryId') required String categoryId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Get hadith by book
  @GET(ApiConstants.hadithByBook)
  Future<HttpResponse<PaginatedResponse<Hadith>>> getHadithByBook({
    @Path('bookId') required String bookId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Get hadith by narrator
  @GET(ApiConstants.hadithByNarrator)
  Future<HttpResponse<PaginatedResponse<Hadith>>> getHadithByNarrator({
    @Path('narratorId') required String narratorId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Get random hadith
  @GET(ApiConstants.randomHadith)
  Future<HttpResponse<Hadith>> getRandomHadith({
    @Query('category') String? category,
    @Query('book') String? book,
  });

  /// Get daily hadith
  @GET(ApiConstants.dailyHadith)
  Future<HttpResponse<DailyHadith>> getDailyHadith();

  // ==================== BOOK ENDPOINTS ====================

  /// Get list of books with pagination and filters
  @GET(ApiConstants.bookList)
  Future<HttpResponse<PaginatedResponse<Book>>> getBookList({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('category') String? category,
    @Query('author') String? author,
    @Query('search') String? search,
    @Query('sort') String? sort,
  });

  /// Get specific book by ID
  @GET(ApiConstants.bookDetail)
  Future<HttpResponse<Book>> getBookDetail(@Path('id') String id);

  /// Search books
  @GET(ApiConstants.bookSearch)
  Future<HttpResponse<PaginatedResponse<Book>>> searchBooks({
    @Query('q') required String query,
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('category') String? category,
  });

  /// Get books by category
  @GET(ApiConstants.bookByCategory)
  Future<HttpResponse<PaginatedResponse<Book>>> getBooksByCategory({
    @Path('categoryId') required String categoryId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Get books by author
  @GET(ApiConstants.bookByAuthor)
  Future<HttpResponse<PaginatedResponse<Book>>> getBooksByAuthor({
    @Path('authorId') required String authorId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Get book chapters
  @GET(ApiConstants.bookChapters)
  Future<HttpResponse<List<Chapter>>> getBookChapters(
    @Path('id') String bookId,
  );

  /// Get book content
  @GET(ApiConstants.bookContent)
  Future<HttpResponse<BookContent>> getBookContent(@Path('id') String bookId);

  // ==================== CATEGORY ENDPOINTS ====================

  /// Get list of categories
  @GET(ApiConstants.categoryList)
  Future<HttpResponse<List<Category>>> getCategoryList();

  /// Get specific category by ID
  @GET(ApiConstants.categoryDetail)
  Future<HttpResponse<Category>> getCategoryDetail(@Path('id') String id);

  /// Get books in category
  @GET(ApiConstants.categoryBooks)
  Future<HttpResponse<PaginatedResponse<Book>>> getCategoryBooks({
    @Path('id') required String categoryId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Get hadith in category
  @GET(ApiConstants.categoryHadith)
  Future<HttpResponse<PaginatedResponse<Hadith>>> getCategoryHadith({
    @Path('id') required String categoryId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  // ==================== AUTHOR ENDPOINTS ====================

  /// Get list of authors
  @GET(ApiConstants.authorList)
  Future<HttpResponse<List<Author>>> getAuthorList();

  /// Get specific author by ID
  @GET(ApiConstants.authorDetail)
  Future<HttpResponse<Author>> getAuthorDetail(@Path('id') String id);

  /// Get books by author
  @GET(ApiConstants.authorBooks)
  Future<HttpResponse<PaginatedResponse<Book>>> getAuthorBooks({
    @Path('id') required String authorId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  // ==================== NARRATOR ENDPOINTS ====================

  /// Get list of narrators
  @GET(ApiConstants.narratorList)
  Future<HttpResponse<List<Narrator>>> getNarratorList();

  /// Get specific narrator by ID
  @GET(ApiConstants.narratorDetail)
  Future<HttpResponse<Narrator>> getNarratorDetail(@Path('id') String id);

  /// Get hadith by narrator
  @GET(ApiConstants.narratorHadith)
  Future<HttpResponse<PaginatedResponse<Hadith>>> getNarratorHadith({
    @Path('id') required String narratorId,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  // ==================== SEARCH ENDPOINTS ====================

  /// Global search across all content types
  @GET(ApiConstants.globalSearch)
  Future<HttpResponse<GlobalSearchResponse>> globalSearch({
    @Query('q') required String query,
    @Query('type') String? type, // hadith, book, author, narrator
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Get search suggestions
  @GET(ApiConstants.searchSuggestions)
  Future<HttpResponse<List<String>>> getSearchSuggestions({
    @Query('q') required String query,
    @Query('limit') int? limit,
  });

  /// Get search history
  @GET(ApiConstants.searchHistory)
  Future<HttpResponse<List<SearchHistoryItem>>> getSearchHistory();

  // ==================== BOOKMARK ENDPOINTS ====================

  /// Get user bookmarks
  @GET(ApiConstants.bookmarkList)
  Future<HttpResponse<PaginatedResponse<Bookmark>>> getBookmarks({
    @Query('type') String? type, // hadith, book
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Add bookmark
  @POST(ApiConstants.addBookmark)
  Future<HttpResponse<Bookmark>> addBookmark(
    @Body() AddBookmarkRequest request,
  );

  /// Remove bookmark
  @DELETE(ApiConstants.removeBookmark)
  Future<HttpResponse<void>> removeBookmark(
    @Body() RemoveBookmarkRequest request,
  );

  /// Get hadith bookmarks
  @GET(ApiConstants.bookmarkHadith)
  Future<HttpResponse<PaginatedResponse<Hadith>>> getHadithBookmarks({
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Get book bookmarks
  @GET(ApiConstants.bookmarkBook)
  Future<HttpResponse<PaginatedResponse<Book>>> getBookBookmarks({
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  // ==================== READING PROGRESS ENDPOINTS ====================

  /// Get reading progress
  @GET(ApiConstants.readingProgress)
  Future<HttpResponse<ReadingProgress>> getReadingProgress();

  /// Update reading progress
  @POST(ApiConstants.updateProgress)
  Future<HttpResponse<ReadingProgress>> updateReadingProgress(
    @Body() UpdateProgressRequest request,
  );

  /// Get reading history
  @GET(ApiConstants.readingHistory)
  Future<HttpResponse<PaginatedResponse<ReadingHistoryItem>>>
  getReadingHistory({@Query('page') int? page, @Query('limit') int? limit});

  // ==================== NOTIFICATION ENDPOINTS ====================

  /// Get user notifications
  @GET(ApiConstants.notifications)
  Future<HttpResponse<PaginatedResponse<Notification>>> getNotifications({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('unread_only') bool? unreadOnly,
  });

  /// Mark notification as read
  @POST(ApiConstants.markAsRead)
  Future<HttpResponse<void>> markNotificationAsRead(
    @Body() MarkAsReadRequest request,
  );

  /// Get notification settings
  @GET(ApiConstants.notificationSettings)
  Future<HttpResponse<NotificationSettings>> getNotificationSettings();

  /// Update notification settings
  @PUT(ApiConstants.notificationSettings)
  Future<HttpResponse<NotificationSettings>> updateNotificationSettings(
    @Body() NotificationSettings request,
  );

  // ==================== QURAN ENDPOINTS ====================

  /// Get Quran verses
  @GET(ApiConstants.quranVerses)
  Future<HttpResponse<PaginatedResponse<QuranVerse>>> getQuranVerses({
    @Query('surah') int? surah,
    @Query('ayah') int? ayah,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  /// Get specific Quran surah
  @GET(ApiConstants.quranSurah)
  Future<HttpResponse<QuranSurah>> getQuranSurah(@Path('id') int surahId);

  /// Search Quran
  @GET(ApiConstants.quranSearch)
  Future<HttpResponse<PaginatedResponse<QuranVerse>>> searchQuran({
    @Query('q') required String query,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  // ==================== UTILITY ENDPOINTS ====================

  /// Get app version information
  @GET(ApiConstants.appVersion)
  Future<HttpResponse<AppVersion>> getAppVersion();

  /// Get app settings
  @GET(ApiConstants.appSettings)
  Future<HttpResponse<AppSettings>> getAppSettings();

  /// Submit feedback
  @POST(ApiConstants.feedback)
  Future<HttpResponse<void>> submitFeedback(@Body() FeedbackRequest request);
}

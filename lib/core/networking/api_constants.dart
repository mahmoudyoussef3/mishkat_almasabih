/// API Constants for Mishkat Al-Masabih Islamic Library App
/// Contains all the endpoint URLs and configuration constants
class ApiConstants {
  // Base URL for the API
  static const String apiBaseUrl = 'https://hadith-shareef.com/api';
  
  // Authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  
  // User management endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String changePassword = '/user/password/change';
  
  // Hadith endpoints
  static const String hadithList = '/hadith';
  static const String hadithDetail = '/hadith/{id}';
  static const String hadithSearch = '/hadith/search';
  static const String hadithByCategory = '/hadith/category/{categoryId}';
  static const String hadithByBook = '/hadith/book/{bookId}';
  static const String hadithByNarrator = '/hadith/narrator/{narratorId}';
  static const String randomHadith = '/hadith/random';
  static const String dailyHadith = '/hadith/daily';
  
  // Book endpoints
  static const String bookList = '/books';
  static const String bookDetail = '/books/{id}';
  static const String bookSearch = '/books/search';
  static const String bookByCategory = '/books/category/{categoryId}';
  static const String bookByAuthor = '/books/author/{authorId}';
  static const String bookChapters = '/books/{id}/chapters';
  static const String bookContent = '/books/{id}/content';
  
  // Category endpoints
  static const String categoryList = '/categories';
  static const String categoryDetail = '/categories/{id}';
  static const String categoryBooks = '/categories/{id}/books';
  static const String categoryHadith = '/categories/{id}/hadith';
  
  // Author endpoints
  static const String authorList = '/authors';
  static const String authorDetail = '/authors/{id}';
  static const String authorBooks = '/authors/{id}/books';
  
  // Narrator endpoints
  static const String narratorList = '/narrators';
  static const String narratorDetail = '/narrators/{id}';
  static const String narratorHadith = '/narrators/{id}/hadith';
  
  // Search endpoints
  static const String globalSearch = '/search';
  static const String searchSuggestions = '/search/suggestions';
  static const String searchHistory = '/search/history';
  
  // Bookmark endpoints
  static const String bookmarkList = '/bookmarks';
  static const String addBookmark = '/bookmarks/add';
  static const String removeBookmark = '/bookmarks/remove';
  static const String bookmarkHadith = '/bookmarks/hadith';
  static const String bookmarkBook = '/bookmarks/book';
  
  // Reading progress endpoints
  static const String readingProgress = '/reading/progress';
  static const String updateProgress = '/reading/progress/update';
  static const String readingHistory = '/reading/history';
  
  // Notification endpoints
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/read';
  static const String notificationSettings = '/notifications/settings';
  
  // Content endpoints
  static const String quranVerses = '/quran/verses';
  static const String quranSurah = '/quran/surah/{id}';
  static const String quranSearch = '/quran/search';
  
  // Utility endpoints
  static const String appVersion = '/app/version';
  static const String appSettings = '/app/settings';
  static const String feedback = '/app/feedback';
  
  // Pagination constants
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Timeout constants
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Cache constants
  static const int cacheMaxAge = 3600; // 1 hour in seconds
  static const int cacheMaxSize = 100; // Maximum number of cached items
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
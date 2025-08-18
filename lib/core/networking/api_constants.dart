/// API Constants for Mishkat Al-Masabih Islamic Library App
/// Contains all the endpoint URLs and configuration constants
class ApiConstants {
  static const String apiBaseUrl = "https://api.hadith-shareef.com/api/";

  static const String login = "auth/login";
  static const String signup = "auth/register";
  static const String getAllBooksWithCategories = "islamic-library/books";

  static const String getLibraryStatistics = "islamic-library/statistics";
  static const String getBooksByCategory =
      "/islamic-library/categories/{categoryId}/books";
  static const String getBookChapters = "/islamic-library/books/{bookSlug}/chapters";
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

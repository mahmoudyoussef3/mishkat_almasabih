import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/networking/caching_helper.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_response.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/collection_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkRepo {
  final ApiService _apiService;

  BookMarkRepo(this._apiService);

  /// Get all user bookmarks (with caching)
  Future<Either<ErrorHandler, BookmarksResponse>> getUserBookMarks() async {
    try {
      final token = await _getUserToken();

      final cacheKey = CacheKeys.bookmarks;

      final cachedData = await GenericCacheService.instance
          .getData<BookmarksResponse>(
            key: cacheKey,
            fromJson: (json) => BookmarksResponse.fromJson(json),
          );

      if (cachedData != null) {
              cachedData!.bookmarks![0].toJson();

        log('cached for bookmarks is $cachedData');

        log('📂 Loaded Ahadith from cache for $id ');
        return Right(cachedData);
      }

      final response = await _apiService.getUserBookmarks(token);

      await GenericCacheService.instance.saveData<BookmarksResponse>(
        key: cacheKey,
        data: response,
        toJson: (data) => data.toJson(),
        cacheExpirationHours: 100,
      );

      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Get bookmark collections (with caching)
  Future<Either<ErrorHandler, CollectionsResponse>>
  getBookmarkCollectionsRepo() async {
    try {
      final token = await _getUserToken();

      final cacheKey = CacheKeys.collectionBookmarksResponse;

      final cachedData = await GenericCacheService.instance
          .getData<CollectionsResponse>(
            key: cacheKey,
            fromJson: (json) => CollectionsResponse.fromJson(json),
          );

      if (cachedData != null) {
        log('📂 Loaded Ahadith from cache for $id ');
        return Right(cachedData);
      }
      final response = await _apiService.getBookmarkCollection(token);
      await GenericCacheService.instance.saveData<CollectionsResponse>(
        key: cacheKey,
        data: response,
        toJson: (data) => data.toJson(),
        cacheExpirationHours: 100,
      );
      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Delete a bookmark by ID
  Future<Either<ErrorHandler, AddBookmarkResponse>> deleteBookMark(
    int bookmarkId,
  ) async {
    try {
      final token = await _getUserToken();
      final response = await _apiService.deleteUserBookmsrk(bookmarkId, token);

      // مسح الكاش بعد الحذف عشان يجيب بيانات جديدة المرة الجاية

      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Add a new bookmark
  Future<Either<ErrorHandler, AddBookmarkResponse>> addBookmark(
    Bookmark body,
  ) async {
    try {
      final token = await _getUserToken();

      final response = await _apiService.addBookmark(token, body);

      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Retrieve user token from SharedPreferences
  Future<String> _getUserToken() async {
    final sharedPref = await SharedPreferences.getInstance();
    final token = sharedPref.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception("No token found, user not logged in");
    }
    return token;
  }
}

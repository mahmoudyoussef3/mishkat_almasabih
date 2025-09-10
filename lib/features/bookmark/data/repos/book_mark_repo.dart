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

  // 🔹 كاش لكل نوع ريسبونس
  final _userBookmarksCache = GenericCache<BookmarksResponse>(
    cacheKey: "user_bookmarks",
    fromJson: (json) => BookmarksResponse.fromJson(json),
  );

  final _collectionsCache = GenericCache<CollectionsResponse>(
    cacheKey: "bookmark_collections",
    fromJson: (json) => CollectionsResponse.fromJson(json),
  );

  /// Get all user bookmarks (with caching)
  Future<Either<ErrorHandler, BookmarksResponse>> getUserBookMarks() async {
    try {
      final cached = await _userBookmarksCache.getData();
      if (cached != null) {
                        log("cache library statistics is $cached");

        return Right(cached);
      }

      final token = await _getUserToken();
      final response = await _apiService.getUserBookmarks(token);

      await _userBookmarksCache.saveData(response);
      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Get bookmark collections (with caching)
  Future<Either<ErrorHandler, CollectionsResponse>> getBookmarkCollectionsRepo() async {
    try {
      final cached = await _collectionsCache.getData();
      if (cached != null) {
                                log("cache library statistics is $cached");

        return Right(cached);
      }

      final token = await _getUserToken();
      final response = await _apiService.getBookmarkCollection(token);

      await _collectionsCache.saveData(response);
      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Delete a bookmark by ID
  Future<Either<ErrorHandler, AddBookmarkResponse>> deleteBookMark(int bookmarkId) async {
    try {
      final token = await _getUserToken();
      final response = await _apiService.deleteUserBookmsrk(bookmarkId, token);

      // مسح الكاش بعد الحذف عشان يجيب بيانات جديدة المرة الجاية
      await _userBookmarksCache.clear();

      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Add a new bookmark
  Future<Either<ErrorHandler, AddBookmarkResponse>> addBookmark(Bookmark body) async {
    try {
      final token = await _getUserToken();
      
      final response = await _apiService.addBookmark(token, body);

      // مسح الكاش بعد الإضافة عشان يجيب بيانات جديدة المرة الجاية
      await _userBookmarksCache.clear();

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

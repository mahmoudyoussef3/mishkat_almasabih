import 'package:dio/dio.dart';
import 'package:mishkat_almasabih/features/authentication/login/data/models/login_response_body.dart';
import 'package:mishkat_almasabih/features/authentication/signup/data/models/sign_up_request_body.dart';
import 'package:mishkat_almasabih/features/authentication/signup/data/models/sign_up_response_body.dart';
import 'package:mishkat_almasabih/features/book_data/data/models/book_data_model.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_response.dart';
import 'package:mishkat_almasabih/features/chapters/data/models/chapters_model.dart';
import 'package:mishkat_almasabih/features/ahadith/data/models/ahadiths_model.dart';
import 'package:mishkat_almasabih/features/ahadith/data/models/local_books_model.dart';
import 'package:mishkat_almasabih/features/home/data/models/book_model.dart';
import 'package:mishkat_almasabih/features/home/data/models/library_statistics_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../features/authentication/login/data/models/login_request_body.dart';
import 'api_constants.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginResponseBody> login(@Body() LoginRequestBody loginRequestBody);

  @POST(ApiConstants.signup)
  Future<SignUpResponseBody> signup(
    @Body() SignupRequestBody signupRequestBody,
  );
  @GET(ApiConstants.getAllBooksWithCategories)
  Future<BooksResponse> getAllBooksWithCategories();
  @GET(ApiConstants.getLibraryStatistics)
  Future<StatisticsResponse> getLibraryStatisctics();

  @GET(ApiConstants.getBooksByCategory)
  Future<CategoryResponse> getBookData(@Path("categoryId") String categoryId);

  @GET(ApiConstants.getBookChapters)
  Future<ChaptersModel> getBookChapters(@Path("bookSlug") String bookSlug);

  @GET(ApiConstants.getChapterAhadiths)
  Future<HadithResponse> getChapterAhadiths(
    @Path("bookSlug") String bookSlug,
    @Path("chapterId") int chapterId,
  );

  @GET(ApiConstants.getChapterAhadiths)
  Future<LocalHadithResponse> getLocalChapterAhadiths(
    @Path("bookSlug") String bookSlug,
    @Path("chapterId") int chapterId,
  );

  @GET(ApiConstants.getLocalChapterAhadiths)
  Future<LocalHadithResponse> getThreeBooksLocalChapterAhadiths(
    @Path("bookSlug") String bookSlug,
    @Path("chapterId") int chapterId,
  );

  @GET(ApiConstants.getBookmarks)
  Future<BookmarksResponse> getUserBookmarks(
    @Header("x-auth-token") String token,
  );

  @DELETE(ApiConstants.deleteBookmark)
  Future<AddBookmarkResponse> deleteUserBookmsrk(
    @Path("bookmarkId") int bookmarkId,

    @Header("x-auth-token") String token,
  );

  @POST(ApiConstants.addBookmark)
  Future<AddBookmarkResponse> addBookmark(
    @Header("x-auth-token") String token,
    @Body() Bookmark body,
  );
}

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mishkat_almasabih/features/authentication/signup/data/repo/signup_repo.dart';
import 'package:mishkat_almasabih/features/authentication/signup/logic/signup_cubit.dart';
import 'package:mishkat_almasabih/features/book_data/data/repos/book_data_repo.dart';
import 'package:mishkat_almasabih/features/book_data/logic/cubit/book_data_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/data/repos/book_mark_repo.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/get_book_chapters/data/repos/book_chapters_repo.dart';
import 'package:mishkat_almasabih/features/get_book_chapters/logic/cubit/get_book_chapters_cubit.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/data/repos/chapter_ahadiths_repo.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/logic/cubit/get_chapter_ahadiths_cubit.dart';
import 'package:mishkat_almasabih/features/home/data/repos/get_all_books_with_categories_repo.dart';
import 'package:mishkat_almasabih/features/home/data/repos/get_library_statistics_repo.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_all_books_with_categories_cubit.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_library_statistics_cubit.dart';
import '../../features/authentication/login/logic/cubit/login_cubit.dart';
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';
import '../../features/authentication/login/data/repo/login_repo.dart';
import '../../features/authentication/login/logic/cubit/login_cubit.dart';

final getIt = GetIt.instance;

Future<void> setUpGetIt() async {
  Dio dio = await DioFactory.getDio();

  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));

  getIt.registerLazySingleton<SignupRepo>(() => SignupRepo(getIt()));
  getIt.registerFactory<SignupCubit>(() => SignupCubit(getIt()));

  getIt.registerLazySingleton<GetAllBooksWithCategoriesRepo>(
    () => GetAllBooksWithCategoriesRepo(getIt()),
  );
  getIt.registerFactory<GetAllBooksWithCategoriesCubit>(
    () => GetAllBooksWithCategoriesCubit(getIt()),
  );

  getIt.registerLazySingleton<GetLibraryStatisticsRepo>(
    () => GetLibraryStatisticsRepo(getIt()),
  );
  getIt.registerFactory<GetLibraryStatisticsCubit>(
    () => GetLibraryStatisticsCubit(getIt()),
  );

  getIt.registerLazySingleton<GetBookDataRepo>(() => GetBookDataRepo(getIt()));
  getIt.registerFactory<BookDataCubit>(() => BookDataCubit(getIt()));

  getIt.registerLazySingleton<BookChaptersRepo>(
    () => BookChaptersRepo(getIt()),
  );
  getIt.registerFactory<GetBookChaptersCubit>(
    () => GetBookChaptersCubit(getIt()),
  );

  getIt.registerLazySingleton<ChapterAhadithsRepo>(
    () => ChapterAhadithsRepo(getIt()),
  );
  getIt.registerFactory<GetChapterAhadithsCubit>(
    () => GetChapterAhadithsCubit(getIt()),
  );

  getIt.registerLazySingleton<BookMarkRepo>(() => BookMarkRepo(getIt()));
  getIt.registerFactory<UserBookmarksCubit>(() => UserBookmarksCubit(getIt()));
}

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mishkat_almasabih/features/authentication/signup/data/repo/signup_repo.dart';
import 'package:mishkat_almasabih/features/authentication/signup/logic/signup_cubit.dart';
import 'package:mishkat_almasabih/features/book_data/data/repos/book_data_repo.dart';
import 'package:mishkat_almasabih/features/book_data/logic/cubit/book_data_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/data/repos/book_mark_repo.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/delete_cubit/cubit/delete_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/chapters/data/repos/chapters_repo.dart';
import 'package:mishkat_almasabih/features/chapters/logic/cubit/chapters_cubit.dart';
import 'package:mishkat_almasabih/features/ahadith/data/repos/ahadiths_repo.dart';
import 'package:mishkat_almasabih/features/ahadith/logic/cubit/ahadiths_cubit.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/hadith_daily/logic/cubit/daily_hadith_cubit.dart';
import 'package:mishkat_almasabih/features/home/data/repos/get_all_books_with_categories_repo.dart';
import 'package:mishkat_almasabih/features/home/data/repos/get_library_statistics_repo.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_all_books_with_categories_cubit.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_library_statistics_cubit.dart';
import 'package:mishkat_almasabih/features/navigation/data/repos/navigation_repo.dart';
import 'package:mishkat_almasabih/features/navigation/logic/cubit/navigation_cubit.dart';
import 'package:mishkat_almasabih/features/navigation/logic/local/cubit/local_hadith_navigation_cubit.dart';
import 'package:mishkat_almasabih/features/search/home_screen/data/repos/public_search_repo.dart';
import 'package:mishkat_almasabih/features/search/home_screen/logic/cubit/public_search_cubit.dart';
import '../../features/authentication/login/logic/cubit/login_cubit.dart';
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';
import '../../features/authentication/login/data/repo/login_repo.dart';

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
  getIt.registerFactory<ChaptersCubit>(() => ChaptersCubit(getIt()));

  getIt.registerLazySingleton<AhadithsRepo>(() => AhadithsRepo(getIt()));
  getIt.registerFactory<AhadithsCubit>(() => AhadithsCubit(getIt()));

  getIt.registerLazySingleton<BookMarkRepo>(() => BookMarkRepo(getIt()));
  getIt.registerFactory<GetBookmarksCubit>(() => GetBookmarksCubit(getIt()));
  getIt.registerFactory<GetCollectionsBookmarkCubit>(
    () => GetCollectionsBookmarkCubit(getIt()),
  );

  getIt.registerFactory<AddCubitCubit>(() => AddCubitCubit(getIt()));
  getIt.registerFactory<DeleteCubitCubit>(() => DeleteCubitCubit(getIt()));

  getIt.registerLazySingleton<PublicSearchRepo>(
    () => PublicSearchRepo(getIt()),
  );
  getIt.registerFactory<PublicSearchCubit>(() => PublicSearchCubit(getIt()));

  getIt.registerLazySingleton<HadithDailyRepo>(() => HadithDailyRepo(getIt()));
  getIt.registerFactory<DailyHadithCubit>(() => DailyHadithCubit(getIt()));

  
  getIt.registerLazySingleton<NavigationRepo>(() => NavigationRepo(getIt()));
  getIt.registerFactory<NavigationCubit>(() => NavigationCubit(getIt()));

    
  getIt.registerFactory<LocalHadithNavigationCubit>(() => LocalHadithNavigationCubit(getIt()));
}

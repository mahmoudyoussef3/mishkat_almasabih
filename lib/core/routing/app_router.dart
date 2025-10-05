import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/features/authentication/signup/logic/signup_cubit.dart';
import 'package:mishkat_almasabih/features/authentication/signup/ui/screens/signup_screen.dart';
import 'package:mishkat_almasabih/features/book_data/logic/cubit/book_data_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/screens/bookmark_screen.dart';
import 'package:mishkat_almasabih/features/chapters/logic/cubit/chapters_cubit.dart';
import 'package:mishkat_almasabih/features/chapters/ui/screens/chapters_screen.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/logic/cubit/daily_hadith_cubit.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/screen/daily_hadith_screen.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_all_books_with_categories_cubit.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_library_statistics_cubit.dart';
import 'package:mishkat_almasabih/features/home/ui/home_screen.dart';
import 'package:mishkat_almasabih/features/library_books_screen.dart';
import 'package:mishkat_almasabih/features/profile/logic/cubit/profile_cubit.dart';
import 'package:mishkat_almasabih/features/profile/ui/profile_screen.dart';
import 'package:mishkat_almasabih/features/random_ahadith/logic/cubit/random_ahadith_cubit.dart';
import 'package:mishkat_almasabih/features/remaining_questions/logic/cubit/remaining_questions_cubit.dart';
import 'package:mishkat_almasabih/features/search/enhanced_public_search/logic/cubit/enhanced_search_cubit.dart';
import 'package:mishkat_almasabih/features/search/search_screen/logic/cubit/search_history_cubit.dart';
import 'package:mishkat_almasabih/features/search_with_filters/logic/cubit/search_with_filters_cubit.dart';
import 'package:mishkat_almasabih/features/search_with_filters/ui/screens/filter_serch_result_screen.dart';
import 'package:mishkat_almasabih/features/search_with_filters/ui/screens/search_with_filters_screen.dart';
import 'package:mishkat_almasabih/features/serag/data/models/serag_request_model.dart';
import 'package:mishkat_almasabih/features/serag/logic/chat_history/chat_history_cubit.dart';
import 'package:mishkat_almasabih/features/serag/logic/cubit/serag_cubit.dart';
import 'package:mishkat_almasabih/features/serag/ui/serag_chat_screen.dart';
import '../../features/home/ui/widgets/public_search_result.dart';
import '../../features/main_navigation/main_navigation_screen.dart';
import '../di/dependency_injection.dart';
import 'routes.dart';
import '../../features/authentication/login/logic/cubit/login_cubit.dart';
import '../../features/authentication/login/ui/screens/login_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/splash/splash_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.signupScreen:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => getIt<SignupCubit>(),
                child: SignupScreen(),
              ),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => getIt<LoginCubit>(),
                child: LoginScreen(),
              ),
        );
      case Routes.mainNavigationScreen:
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create:
                        (context) => getIt<GetAllBooksWithCategoriesCubit>(),
                  ),
                  BlocProvider(
                    create: (context) => getIt<GetLibraryStatisticsCubit>(),
                  ),

                  BlocProvider(create: (context) => getIt<BookDataCubit>()),
                  BlocProvider(create: (context) => getIt<GetBookmarksCubit>()),
                  BlocProvider(create: (context) => getIt<DailyHadithCubit>()),
                  BlocProvider(create: (context) => getIt<AddCubitCubit>()),
                  BlocProvider(create: (context) => SearchHistoryCubit()),
                  BlocProvider(
                    create:
                        (context) =>
                            customGetIt<RandomAhadithCubit>()
                              ..emitRandomStats(),
                  ),
                ],
                child: const MainNavigationScreen(),
              ),
        );

      case Routes.homeScreen:
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create:
                        (context) => getIt<GetAllBooksWithCategoriesCubit>(),
                  ),
                  BlocProvider(
                    create: (context) => getIt<GetLibraryStatisticsCubit>(),
                  ),

                  BlocProvider(create: (context) => getIt<BookDataCubit>()),
                  BlocProvider(create: (context) => getIt<DailyHadithCubit>()),
                  BlocProvider(create: (context) => SearchHistoryCubit()),
                  BlocProvider(
                    create:
                        (context) =>
                            customGetIt<RandomAhadithCubit>()
                              ..emitRandomStats(),
                  ),
                ],
                child: const HomeScreen(),
              ),
        );
      case Routes.searchScreen:
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
              
                  BlocProvider(create: (context) => getIt<SearchWithFiltersCubit>()),
        BlocProvider(create: (context) => SearchHistoryCubit()),

                  BlocProvider(create: (context) => getIt<GetBookmarksCubit>()),
                  BlocProvider(create: (context) => getIt<AddCubitCubit>()),
                
                ],
                child: const SearchWithFiltersScreen(),
              ),
        );
     case Routes.profileScreen:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                      create: (context) => getIt<ProfileCubit>()..getUserProfile(),

       
                child: const ProfileScreen(),
              ),
        );

     case Routes.bookmarkScreen:
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                BlocProvider(
          create: (_) => getIt<GetBookmarksCubit>()..getUserBookmarks(),
        ),
        BlocProvider(
          create:
              (_) =>
                  getIt<GetCollectionsBookmarkCubit>()
                    ..getBookMarkCollections(),
        ),

                
                ],
                child: const BookmarkScreen(),
              ),
        );
           case Routes.libraryScreen:
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
          BlocProvider(
                    create:
                        (context) => getIt<GetAllBooksWithCategoriesCubit>(),
                  ),
                  BlocProvider(
                    create: (context) => getIt<GetLibraryStatisticsCubit>(),
                  ),
                
                ],
                child: const LibraryBooksScreen(),
              ),
        );


      case Routes.bookChaptersScreen:
        final args = settings.arguments as List<dynamic>;
        final bookSlug = args[0];
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) =>
                        getIt<ChaptersCubit>()..emitGetBookChapters(bookSlug),
                child: BookChaptersScreen(args: args),
              ),
        );
      case Routes.publicSearchSCreen:
        final query = settings.arguments as String;
        log(query);

        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) =>
                        getIt<EnhancedSearchCubit>()
                          ..fetchEnhancedSearchResults(query),

                child: PublicSearchResult(searchQuery: query),
              ),
        );

      case Routes.filterResultSearch:
        final query = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) =>
                        getIt<SearchWithFiltersCubit>()..emitSearchWithFilters(
                          bookSlug: query['book'] ?? '',
                          category: query['category'] ?? '',
                          chapterNumber: query['chapter'] ?? '',
                          grade: query['grade'] ?? '',
                          narrator: query['narrator'] ?? '',
                          searchQuery: query['search'] ?? '',
                        ),
                child: FilterSerchResultScreen(
                  searchQuery: query['search'] ?? '',
                ),
              ),
        );
      /*
      case Routes.searchScreen:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => SearchHistoryCubit(),
                child: SearchScreen(),
              ),
        );
        */
      case Routes.hadithOfTheDay:
        final query = settings.arguments as HadithData;

        return MaterialPageRoute(
          builder:
              (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => getIt<DailyHadithCubit>()),
                  BlocProvider(create: (context) => getIt<AddCubitCubit>()),
                ],
                child: HadithDailyScreen(dailyHadithModel: query),
              ),
        );
      case Routes.serag:
        final query = settings.arguments as SeragRequestModel;

        return MaterialPageRoute(
          builder:
              (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create:
                        (context) =>
                            getIt<RemainingQuestionsCubit>()
                              ..emitRemainingQuestions(),
                  ),

                  BlocProvider(create: (context) => getIt<SeragCubit>()),
                  BlocProvider(
                    create: (context) => ChatHistoryCubit()..clearMessages(),
                  ),
                ],
                child: SeragChatScreen(model: query),
              ),
        );

      default:
        return null;
    }
  }
}

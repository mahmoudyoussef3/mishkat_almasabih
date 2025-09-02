import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/features/authentication/signup/logic/signup_cubit.dart';
import 'package:mishkat_almasabih/features/authentication/signup/ui/screens/signup_screen.dart';
import 'package:mishkat_almasabih/features/book_data/logic/cubit/book_data_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/chapters/logic/cubit/chapters_cubit.dart';
import 'package:mishkat_almasabih/features/chapters/ui/screens/chapters_screen.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/logic/cubit/daily_hadith_cubit.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/screen/daily_hadith_screen.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_all_books_with_categories_cubit.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_library_statistics_cubit.dart';
import 'package:mishkat_almasabih/features/search/home_screen/logic/cubit/public_search_cubit.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/repos/shared_pref_history_item_repo.dart';
import 'package:mishkat_almasabih/features/search/search_screen/logic/cubit/search_history_cubit.dart';
import 'package:mishkat_almasabih/features/search/search_screen/ui/search_screen.dart';
import 'package:mishkat_almasabih/features/search_with_filters/logic/cubit/search_with_filters_cubit.dart';

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
                ],
                child: const MainNavigationScreen(),
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
        final query = settings.arguments as Map<String, String>;
        print(query);

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

//                        getIt<PublicSearchCubit>()..emitPublicSearch(query),
                        
                child: PublicSearchResultScreen(searchQuery: query['search']??''),
              ),
        );

      case Routes.searchScreen:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => SearchHistoryCubit(),
                child: SearchScreen(),
              ),
        );
      case Routes.hadithOfTheDay:
        final query = settings.arguments as DailyHadithModel;

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

      default:
        return null;
    }
  }
}

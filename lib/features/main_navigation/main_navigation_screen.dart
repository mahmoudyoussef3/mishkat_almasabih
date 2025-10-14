import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/screens/bookmark_screen.dart';
import 'package:mishkat_almasabih/features/profile/logic/cubit/profile_cubit.dart';
import 'package:mishkat_almasabih/features/profile/ui/profile_screen.dart';
import 'package:mishkat_almasabih/features/random_ahadith/logic/cubit/random_ahadith_cubit.dart';
import 'package:mishkat_almasabih/features/search/search_screen/logic/cubit/search_history_cubit.dart';
import 'package:mishkat_almasabih/features/search_with_filters/logic/cubit/search_with_filters_cubit.dart';
import 'package:mishkat_almasabih/features/search_with_filters/ui/screens/search_with_filters_screen.dart';
import '../home/ui/home_screen.dart';
import 'widgets/build_bottom_nva_container.dart';
/*
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _BottomNavManagerScreenState();
}

class _BottomNavManagerScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchHistoryCubit()),
                                    BlocProvider(create: (context) => customGetIt<RandomAhadithCubit>()..emitRandomStats()),
      ],
      child: HomeScreen(),
    ),

    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SearchWithFiltersCubit>()),
        BlocProvider(create: (context) => SearchHistoryCubit()),
      ],
      child: SearchWithFiltersScreen(),
    ),
    MultiBlocProvider(
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
      child: BookmarkScreen(),
    ),
    BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          body: _screens[_currentIndex],
          extendBody: true,
          bottomNavigationBar: BuildBottomNavBarContainer(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
        ),
      ),
    );
  }
}
*/
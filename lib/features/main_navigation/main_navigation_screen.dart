import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/screens/bookmark_screen.dart';

import 'package:mishkat_almasabih/features/profile/ui/profile_screen.dart';
import 'package:mishkat_almasabih/features/search/search_screen/logic/cubit/search_history_cubit.dart';
import 'package:mishkat_almasabih/features/search_with_filters/logic/cubit/search_with_filters_cubit.dart';
import 'package:mishkat_almasabih/features/search_with_filters/ui/screens/search_with_filters_screen.dart';

import '../home/ui/home_screen.dart';
import '../search/search_screen/ui/search_screen.dart';
import 'widgets/build_bottom_nva_container.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _BottomNavManagerScreenState();
}

class _BottomNavManagerScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),

    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SearchWithFiltersCubit>()),
        BlocProvider(create: (context) => SearchHistoryCubit()),
      ],
      child: SearchWithFiltersScreen(),
    ),
    BlocProvider(
      create: (context) => getIt<GetBookmarksCubit>(),
      child: BookmarkScreen(),
    ),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _screens[_currentIndex],
        extendBody: true,
        bottomNavigationBar: BuildBottomNavBarContainer(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}

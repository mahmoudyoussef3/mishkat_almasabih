import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/screens/bookmark_screen.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/screen/daily_hadith_screen.dart';
import 'package:mishkat_almasabih/features/notification/test_notification_screen.dart';

import '../home/ui/home_screen.dart';
import '../search/search_screen.dart';
import 'widgets/build_bottom_nva_container.dart';
/*
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    LibraryScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsManager.white,
          child: const Icon(Icons.search, color: ColorsManager.primaryGreen),
          onPressed: () {},
        ),
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: BottomNavigationWidget(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}
*/

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _BottomNavManagerScreenState();
}

class _BottomNavManagerScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),

    HadithDailyScreen(),
    // SearchScreen(),
    // TestNotificationScreen(),
    BlocProvider(
      create: (context) => getIt<GetBookmarksCubit>(),
      child: BookmarkScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsManager.cardBackground,

          child: Icon(Icons.search, color: ColorsManager.primaryGreen),

          onPressed:
              () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('لسه متعملتش يسطااا'))),
        ),
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

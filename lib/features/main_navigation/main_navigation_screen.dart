import 'package:flutter/material.dart';

import '../../core/theming/colors.dart';
import '../../core/widgets/bottom_navigation_widget.dart';
import '../home/ui/home_screen.dart';
import '../search/search_screen.dart';
import '../library/ui/screens/library_screen.dart';

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

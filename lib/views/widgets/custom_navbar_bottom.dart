import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/* This file contains the NavBottom widget which implements a bottom navigation bar
 * using CurvedNavigationBar. It allows users to navigate between different screens
 * in the application.
 */
class NavBottom extends StatefulWidget {
  const NavBottom({super.key});

  @override
  State<NavBottom> createState() => _NavBottomState();
}

class _NavBottomState extends State<NavBottom> {
  int _currentScreen = 0;

  final List<Widget> _screens = const [
    // Home(),
    // PengaduanPage(),
    // RiwayatPengaduan(),
    // Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentScreen != 0) {
          setState(() {
            _currentScreen = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: IndexedStack(
          index: _currentScreen,
          children: _screens,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          color: AppColors.secondary,
          animationCurve: Curves.easeIn,
          animationDuration: const Duration(milliseconds: 200),
          backgroundColor: AppColors.primary,
          onTap: (index) {
            setState(() {
              _currentScreen = index;
            });
          },
          items: const [
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.add, color: Colors.white),
            Icon(Icons.history, color: Colors.white),
            Icon(Icons.people, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

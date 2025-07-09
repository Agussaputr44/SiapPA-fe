import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class NavBottom extends StatefulWidget {
  const NavBottom({super.key});

  @override
  State<NavBottom> createState() => _NavBottomState();
}

class _NavBottomState extends State<NavBottom> {
  final List<String> _routes = [
    '/home',
    '/pengaduan',
    '/history',
    '/profile',
  ];

  int _currentScreen = 0;

  void _navigateTo(int index) {
    setState(() {
      _currentScreen = index;
    });

    Navigator.pushNamedAndRemoveUntil(
      context,
      _routes[index],
      (route) => false, // optional: remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: const SizedBox(), // Kosong karena konten muncul di routes
      bottomNavigationBar: CurvedNavigationBar(
        color: AppColors.secondary,
        backgroundColor: AppColors.primary,
        animationCurve: Curves.easeIn,
        animationDuration: const Duration(milliseconds: 200),
        onTap: _navigateTo,
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.add, color: Colors.white),
          Icon(Icons.history, color: Colors.white),
          Icon(Icons.people, color: Colors.white),
        ],
      ),
    );
  }
}

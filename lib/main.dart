import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siappa/providers/filters_provider.dart';
import 'package:siappa/views/screens/admins/article/add_article_screen.dart';
import 'package:siappa/views/screens/admins/article/detail_article_screen.dart';
import 'package:siappa/views/screens/admins/article/article_screen.dart';
import 'package:siappa/views/screens/admins/dashboard/dashboard_screen.dart';
import 'package:siappa/views/screens/admins/laporan/laporan_screen.dart';
import 'package:siappa/views/screens/auth/login_screen.dart';
import 'package:siappa/views/screens/auth/register_screen.dart';

import 'providers/auth_provider.dart';
import 'views/screens/splash/splash_screen.dart';

/* SiapPA - Sistem Informasi dan Aplikasi Pengaduan Perempuan dan Anak
 * created by @Agussaputr44
 * @version 1.0.0
 * date 2025-06-20
 * Main entry point for SiapPA application.
 * This file initializes the app and sets up the main widget tree.
 */

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FiltersProvider()),
      ],
      child: MaterialApp(
        title: 'SiapPA',
        theme: ThemeData(colorSchemeSeed: Colors.transparent),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/laporan': (context) => const LaporanScreen(),
          '/artikel': (context) => const ArticleScreen(),
          '/artikel/detail': (context) => const DetailArticleScreen(),
          '/artikel/add': (context) => const AddArticleScreen(),
        //   '/home': (context) => const NavBottom(),
        //   '/pengaduan': (context) => const PengaduanPage(),
        //   '/riwayat_pengaduan': (context) => const RiwayatPengaduan(),
        //   '/profile': (context) => const Profile(),
        },
      ),
    );
  }
}

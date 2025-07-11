import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siappa/providers/articles_provider.dart';
import 'package:siappa/providers/filters_provider.dart';
import 'package:siappa/providers/pengaduans_provider.dart';
import 'package:siappa/providers/upload_media_provider.dart';
import 'package:siappa/providers/users_provider.dart';
import 'package:siappa/views/screens/admins/article/add_article_screen.dart';
import 'package:siappa/views/screens/admins/article/detail_article_screen.dart';
import 'package:siappa/views/screens/admins/article/article_screen.dart';
import 'package:siappa/views/screens/admins/article/update_article_screen.dart';
import 'package:siappa/views/screens/admins/dashboard/dashboard_screen.dart';
import 'package:siappa/views/screens/admins/pengaduans/pengaduans_screen.dart';
import 'package:siappa/views/screens/admins/profile/profile_screen.dart';
import 'package:siappa/views/screens/admins/users/users_screen.dart';
import 'package:siappa/views/screens/auth/login_screen.dart';
import 'package:siappa/views/screens/auth/register_screen.dart';
import 'package:siappa/views/screens/users/beranda/all_article_users_screen.dart';
import 'package:siappa/views/screens/users/beranda/beranda_screen.dart';
import 'package:siappa/views/screens/users/history/detail_pengaduan_screen.dart';
import 'package:siappa/views/screens/users/history/history_pengaduan_screen.dart';
import 'package:siappa/views/screens/users/pengaduans/pengaduan_users_screen.dart';
import 'package:siappa/views/screens/users/profile/profile_users_screen.dart';
import 'package:siappa/views/widgets/custom_navbar_bottom.dart';

import 'providers/auth_provider.dart';
import 'views/screens/splash/splash_screen.dart';
import 'views/screens/users/beranda/detail_article_users_screen.dart';

/// SiapPA - Sistem Informasi dan Aplikasi Pengaduan Perempuan dan Anak
/// created by @Agussaputr44
/// @version 1.0.0
/// date 2025-06-20
///
/// Titik masuk utama (main entry point) aplikasi SiapPA.
/// File ini menginisialisasi aplikasi dan membangun widget tree utama,
/// serta mengatur dependency provider dan routing utama aplikasi.
///

void main(){
  runApp(Main());
}
class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FiltersProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => ArticlesProvider()),
        ChangeNotifierProvider(create: (_) => UploadMediaProvider()),
        ChangeNotifierProvider(create: (_) => PengaduansProvider()),
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
          '/register': (context) => RegisterScreen(),
          '/profile': (context)=> ProfileScreen(),
          '/laporan': (context) => const PengaduansScreen(),
          '/users': (context) => const UsersScreen(),
          '/artikel': (context) => const ArticleScreen(),
          '/artikel/detail': (context) => const DetailArticleScreen(),
          '/artikel/add': (context) => const AddArticleScreen(),
          '/artikel/update': (context) => const UpdateArticleScreen(),






          // users
          '/home': (context) => const HomeScreen(),
          '/users/artikel/detail': (context) => const DetailArticleUsersScreen(),
          '/users/artikel/all': (context) => const AllArticleUsersScreen(),
          '/users/pengaduan': (context) => const PengaduanUsersScreen(),
          '/navbar': (context) => const NavBottom(),
          '/users/profile': (context) => const ProfileUsersScreen(),
          '/pengaduan/history': (context)=>HistoryPengaduanScreen()
        },
      ),
    );
  }
}

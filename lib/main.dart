import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        // ChangeNotifierProvider(create: (_) => AuthProviderApp()),
        // ChangeNotifierProvider(create: (_) => PengaduanProvider()),
      ],
      child: MaterialApp(
        title: 'Panda App',
        theme: ThemeData(colorSchemeSeed: Colors.transparent),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        // routes: {
        //   '/': (context) => const SplashScreen(),
        //   '/nav': (context) => const NavBottom(),
        //   '/login': (context) => const LoginPage(),
        //   '/home': (context) => const NavBottom(),
        //   '/pengaduan': (context) => const PengaduanPage(),
        //   '/riwayat_pengaduan': (context) => const RiwayatPengaduan(),
        //   '/profile': (context) => const Profile(),
        // },
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siappa/views/widgets/logo_effect.dart';
import 'package:siappa/providers/auth_provider.dart';

/// SplashScreen
///
/// Halaman splash untuk aplikasi SIAPPA.
/// - Menampilkan animasi logo aplikasi.
/// - Melakukan pengecekan status autentikasi user.
/// - Jika user sudah login (token valid), langsung navigasi ke Dashboard.
/// - Jika belum login, diarahkan ke halaman Login.
///
/// Alur:
/// 1. Saat splash dijalankan, [_checkAuth] di-trigger dari [initState].
/// 2. [_checkAuth] akan:
///    - Memanggil [AuthProvider.loadToken()] untuk mengambil token dari storage.
///    - Menunggu 2 detik agar animasi splash terlihat.
///    - Jika token ada dan valid, navigasi ke '/dashboard'.
///    - Jika tidak, navigasi ke '/login'.
///
/// Gunakan SplashScreen sebagai initialRoute di aplikasi agar fitur auto-login berjalan.
///
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  /// Mengecek apakah user sudah login dengan melihat token dari [AuthProvider].
  /// Navigasi otomatis ke dashboard jika sudah login, atau ke login jika belum.
  Future<void> _checkAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await authProvider.loadToken();
    await authProvider.loadRole();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      if (authProvider.isAdmin) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/navbar');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/wp.png',
            fit: BoxFit.cover,
          ),
          // Centered logo effect/animation
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                LogoEffect(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

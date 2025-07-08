import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:siappa/utils/app_size.dart';
import 'package:siappa/views/widgets/loading_widget.dart';

import '../../../providers/auth_provider.dart';
import '../../widgets/messages_widget.dart';

/// Layar Registrasi Aplikasi
///
/// `RegisterScreen` adalah `StatefulWidget` yang menangani tampilan dan logika
/// pendaftaran pengguna. Ini mengelola status pemuatan gabungan dari `AuthProvider`
/// (untuk proses otentikasi umum seperti pendaftaran email/kata sandi) dan
/// status pemuatan spesifik untuk pendaftaran Google.
///
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// Status pemuatan spesifik untuk proses masuk dengan Google.
  bool _isGoogleSignInLoading = false;

  /// Callback untuk memperbarui status pemuatan masuk Google.
  ///
  /// Digunakan oleh widget anak (`_BottomPortion`) untuk memberi tahu widget induk
  /// tentang perubahan status pemuatan pendaftaran Google.
  void _setGoogleSignInLoading(bool isLoading) {
    setState(() {
      _isGoogleSignInLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mendengarkan status 'isLoading' dari AuthProvider untuk proses otentikasi umum.
    final authProviderIsLoading = Provider.of<AuthProvider>(context).isLoading;

    // Menggabungkan kedua status pemuatan: pemuatan AuthProvider umum ATAU pemuatan spesifik Google Sign-In.
    final overallLoading = authProviderIsLoading || _isGoogleSignInLoading;

    return LoadingWidget(
      isLoading: overallLoading,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Gambar latar belakang
            Image.asset(
              'assets/images/wp.png',
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: AppSize.appWidth * 0.15,
                      height: AppSize.appHeight * 0.15,
                    ),
                  ),
                ),
                // Meneruskan status pemuatan keseluruhan dan callback ke _BottomPortion
                _BottomPortion(
                  overallLoading: overallLoading,
                  onGoogleSignInLoadingChange: _setGoogleSignInLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Bagian Bawah Layar Registrasi
///
/// `_BottomPortion` adalah `StatefulWidget` yang berisi formulir pendaftaran
/// (nama, email, kata sandi) dan opsi pendaftaran Google.
/// Ia menerima status pemuatan keseluruhan dari induknya dan memiliki callback
/// untuk memberi tahu induk tentang status pemuatan masuk Google.
class _BottomPortion extends StatefulWidget {
  /// Status pemuatan keseluruhan yang diteruskan dari widget induk.
  final bool overallLoading;

  /// Callback untuk memberi tahu induk tentang perubahan status pemuatan masuk Google.
  final ValueChanged<bool> onGoogleSignInLoadingChange;

  const _BottomPortion({
    Key? key,
    required this.overallLoading,
    required this.onGoogleSignInLoadingChange,
  }) : super(key: key);

  @override
  State<_BottomPortion> createState() => _BottomPortionState();
}

class _BottomPortionState extends State<_BottomPortion> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  /// Memvalidasi input email.
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Email tidak valid';
    return null;
  }

  /// Memvalidasi input nama.
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Nama tidak boleh kosong';
    return null;
  }

  /// Memvalidasi input kata sandi.
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Kata sandi tidak boleh kosong';
    if (value.length < 8) return 'Kata sandi minimal 8 karakter';
    return null;
  }

  /// Memvalidasi input konfirmasi kata sandi.
  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi kata sandi tidak boleh kosong';
    }
    if (value != _passwordController.text) return 'Kata sandi tidak sama';
    return null;
  }

  /// Menangani proses pendaftaran menggunakan Google Sign-In.
  ///
  /// Ini mengatur status pemuatan Google Sign-In, mencoba masuk dengan Google,
  /// dan kemudian memanggil `AuthProvider` untuk menyelesaikan pendaftaran.
  /// Ini juga menangani pesan sukses/error dan navigasi.
  Future<void> _handleGoogleSignIn() async {
    widget.onGoogleSignInLoadingChange(
        true); // Beri tahu induk untuk menampilkan pemuatan Google
    final googleSignIn = GoogleSignIn();
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        MessagesWidget.showInfo(context, 'Pendaftaran dibatalkan.');
        return; // Tidak perlu mengatur loading ke false di sini, blok finally menanganinya
      }
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        MessagesWidget.showError(context,
            'Gagal mendapatkan ID Token dari Google. Silakan coba lagi.');
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // Memanggil metode loginWithGoogle di AuthProvider Anda.
      // Anda mungkin perlu metode 'registerWithGoogle' khusus jika alurnya berbeda.
      await authProvider.loginWithGoogle(idToken);

      if (!mounted) return;
      MessagesWidget.showSuccess(
          context, 'Pendaftaran berhasil, selamat datang!');
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      String errorMessage = "Terjadi kesalahan, silakan coba lagi.";
      if (e.toString().contains('sign_in_failed')) {
        errorMessage =
            "Pendaftaran gagal, akun Google tidak valid atau telah dibatalkan.";
      } else if (e.toString().contains('network_error')) {
        errorMessage =
            "Tidak dapat terhubung ke Google, periksa internet Anda.";
      } else if (e.toString().contains('popup_closed_by_user')) {
        errorMessage = "Pendaftaran dibatalkan oleh pengguna.";
      } else if (e.toString().contains('Gagal mendapatkan ID Token')) {
        errorMessage = "Gagal mendapatkan ID Token dari Google, coba lagi.";
      } else if (e.toString().contains('account_exists')) {
        errorMessage = "Akun Google ini sudah terdaftar.";
      }
      if (mounted) {
        MessagesWidget.showError(context, errorMessage);
      }
    } finally {
      if (mounted) {
        widget.onGoogleSignInLoadingChange(
            false); // Beri tahu induk untuk menyembunyikan pemuatan
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Status pemuatan sekarang disediakan oleh induk melalui widget.overallLoading
    final bool isLoading = widget.overallLoading;

    return Container(
      width: AppSize.appWidth * 0.5,
      height: AppSize.appHeight * 0.6,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(241, 140, 176, 1),
            Color.fromRGBO(248, 187, 208, 1),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                'Sistem Informasi Aduan dan Perlindungan Perempuan dan Anak',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                cursorColor: Colors.white,
                style: GoogleFonts.poppins(color: Colors.white),
                validator: _validateName,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                  prefixIcon: const Icon(Icons.person, color: Colors.white),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.white,
                style: GoogleFonts.poppins(color: Colors.white),
                validator: _validateEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                  prefixIcon: const Icon(Icons.email, color: Colors.white),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                cursorColor: Colors.white,
                style: GoogleFonts.poppins(color: Colors.white),
                validator: _validatePassword,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi',
                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirmController,
                obscureText: _obscureConfirm,
                cursorColor: Colors.white,
                style: GoogleFonts.poppins(color: Colors.white),
                validator: _validateConfirm,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Kata Sandi',
                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                // Nonaktifkan jika overallLoading true
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          // Ini menggunakan isLoading internal AuthProvider
                          bool result = await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .register(
                            _nameController.text,
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (result) {
                            MessagesWidget.showSuccess(
                                context,
                                Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .successMessage ??
                                    'Registrasi berhasil!');
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          } else {
                            MessagesWidget.showError(
                                context,
                                Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .errorMessage ??
                                    'Registrasi gagal.');
                            _clearField();
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.pink,
                  minimumSize: Size(AppSize.appWidth * 0.7, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Daftar'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Sudah punya akun? Masuk di sini",
                  style: GoogleFonts.poppins(color: Colors.black54),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: const Text('Atau'),
              ),
              ElevatedButton.icon(
                // Nonaktifkan tombol jika overallLoading true
                onPressed: isLoading ? null : _handleGoogleSignIn,
                icon: Image.asset(
                  'assets/images/google.png',
                  width: 20,
                  height: 20,
                ),
                label: const Text('Daftar dengan Google'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.pink,
                  minimumSize: Size(AppSize.appWidth * 0.7, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Mengosongkan semua field input formulir.
  void _clearField() {
    FocusScope.of(context).requestFocus(FocusNode());
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmController.clear();
  }
}

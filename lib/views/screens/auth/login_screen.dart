import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:siappa/views/widgets/loading_widget.dart';
import '../../../providers/auth_provider.dart';
import '../../../utils/app_size.dart';
import '../../widgets/messages_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Email tidak valid';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 8) return 'Password minimal 8 karakter';
    return null;
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final googleSignIn = GoogleSignIn();
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        MessagesWidget.showInfo(context, 'Login dibatalkan.');
        setState(() => _isLoading = false);
        return;
      }
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        MessagesWidget.showError(context, 'Gagal mendapatkan ID Token dari Google. Silakan coba lagi.');
        setState(() => _isLoading = false);
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.loginWithGoogle(idToken);

      if (!mounted) return;
      MessagesWidget.showSuccess(context, 'Login berhasil, selamat datang!');
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      String errorMessage = "Terjadi kesalahan, silakan coba lagi.";
      if (e.toString().contains('sign_in_failed')) {
        errorMessage = "Login gagal, akun Google tidak valid atau telah dibatalkan.";
      } else if (e.toString().contains('network_error')) {
        errorMessage = "Tidak dapat terhubung ke Google, periksa internet Anda.";
      } else if (e.toString().contains('popup_closed_by_user')) {
        errorMessage = "Login dibatalkan oleh pengguna.";
      } else if (e.toString().contains('Gagal mendapatkan ID Token')) {
        errorMessage = "Gagal mendapatkan ID Token dari Google, coba lagi.";
      }
      if (mounted) {
        MessagesWidget.showError(context, errorMessage);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return LoadingWidget(
      isLoading: _isLoading,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/wp.png',
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: AppSize.appWidth * 0.15,
                    height: AppSize.appHeight * 0.15,
                  ),
                ),
                const Spacer(),
                _BottomPortion(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                  validateEmail: _validateEmail,
                  validatePassword: _validatePassword,
                  isLoading: _isLoading,
                  onGoogleSignIn: _handleGoogleSignIn,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomPortion extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final String? Function(String?) validateEmail;
  final String? Function(String?) validatePassword;
  final bool isLoading;
  final VoidCallback onGoogleSignIn;

  const _BottomPortion({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.validateEmail,
    required this.validatePassword,
    required this.isLoading,
    required this.onGoogleSignIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = AppSize.appWidth * 0.5;
    final double height = AppSize.appHeight * 0.55;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.pink[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.white,
                style: GoogleFonts.poppins(color: Colors.white),
                validator: validateEmail,
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
                controller: passwordController,
                obscureText: obscurePassword,
                cursorColor: Colors.white,
                style: GoogleFonts.poppins(color: Colors.white),
                validator: validatePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: GoogleFonts.poppins(color: Colors.white),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: onTogglePassword,
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Tambahkan logika untuk "Forgot Password"
                  },
                  child: Text(
                    'Forgot Password',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: isLoading ? null : () {}, // Tambahkan login email/password jika diperlukan
              //   style: ElevatedButton.styleFrom(
              //     foregroundColor: Colors.pink,
              //     minimumSize: Size(width * 0.7, 50),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   child: isLoading
              //       ? const CircularProgressIndicator(color: Colors.white)
              //       : const Text('Sign In'),
              // ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text(
                  "Do you have any account? Sign Up here",
                  style: GoogleFonts.poppins(color: Colors.black54),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: const Text('Or'),
              ),
              ElevatedButton.icon(
                onPressed: isLoading ? null : onGoogleSignIn,
                icon: Image.asset(
                  'assets/images/google.png',
                  width: 20,
                  height: 20,
                ),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.pink,
                  minimumSize: Size(width * 0.7, 50),
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
}
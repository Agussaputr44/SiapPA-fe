import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';

/* 
 * This file contains the AuthProvider class which manages authentication state
 * and provides methods for login with Google, logout, and token management.
 * It uses ChangeNotifier to notify listeners of changes in authentication state.
 */
class AuthProvider with ChangeNotifier {
  String? _token;
  final AuthService _authService = AuthService();
  final _storage = FlutterSecureStorage();

  String? get token => _token;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    loadToken();
  }

  // login with google provider method
  Future<void> loginWithGoogle(String idToken) async {
    try {
      final token = await _authService.loginWithGoogle(idToken);
      if (token != null) {
        _token = token;
        await _setToken(token);
        notifyListeners();
      } else {
        throw Exception('Login dengan Google gagal: Token tidak diterima');
      }
    } catch (e) {
      throw Exception('Login dengan Google gagal: $e');
    }
  }

  Future<void> logout() async {
    try {
      _token = null;
      
      await _storage.delete(key: 'auth_token');
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal logout: $e');
    }
  }

  Future<void> _setToken(String token) async {
    try {
      await _storage.write(key: 'auth_token', value: token);
    } catch (e) {
      throw Exception('Gagal menyimpan token: $e');
    }
  }

  Future<String?> loadToken() async {
    try {
      _token = await _storage.read(key: 'auth_token');
      notifyListeners();
      return _token;
    } catch (e) {
      throw Exception('Gagal memuat token: $e');
    }
  }
}

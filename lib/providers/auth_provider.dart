import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';

/// AuthProvider manages authentication state, login, logout, and token persistence.
/// Uses [ChangeNotifier] to notify listeners when auth state changes.
class AuthProvider with ChangeNotifier {
  String? _token;
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Get current token (nullable)
  String? get token => _token;

  // pesan sukses
  String? _successMessage;
  String? get successMessage => _successMessage;

  // pesan error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// True if user is authenticated (token is not null)
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    loadToken();
  }

  /// Login with Google and store token
  Future<void> loginWithGoogle(String idToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await _authService.loginWithGoogle(idToken);
      _token = token;
      await _setToken(token);
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Login dengan Google gagal: $e\n$stack');
      throw Exception('Login dengan Google gagal: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await _authService.login(email, password);
      _token = token;
      await _setToken(token);
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Login gagal: $e\n$stack');
      throw Exception('Login gagal: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// register
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _successMessage = null;
    _errorMessage = null;
    notifyListeners();

    try {
      final message = await _authService.register(name, email, password);
      _successMessage = message;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout and clear token from secure storage
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_token != null) {
        await _authService.logout(_token!);
        debugPrint("Logout API call success");
      }

      _token = null;
      await _storage.delete(key: 'auth_token');
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Gagal logout: $e\n$stack');
      throw Exception('Gagal logout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set token in secure storage
  Future<void> _setToken(String token) async {
    try {
      await _storage.write(key: 'auth_token', value: token);
    } catch (e, stack) {
      debugPrint('Gagal menyimpan token: $e\n$stack');
      throw Exception('Gagal menyimpan token: $e');
    }
  }

  /// Load token from secure storage
  Future<String?> loadToken() async {
    try {
      _token = await _storage.read(key: 'auth_token');
      notifyListeners();
      return _token;
    } catch (e, stack) {
      debugPrint('Gagal memuat token: $e\n$stack');
      throw Exception('Gagal memuat token: $e');
    }
  }

  /// Optional: Clear all secure storage (for full logout or reset)
  Future<void> clearAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _storage.deleteAll();
      _token = null;
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Gagal clear secure storage: $e\n$stack');
      throw Exception('Gagal clear secure storage: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

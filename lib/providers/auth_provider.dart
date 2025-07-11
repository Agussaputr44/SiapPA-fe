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

  String? _role;
  String? get role => _role;

  bool get isAdmin => _role == 'admin';

  AuthProvider() {
    loadRole();
    loadToken();
  }

  Future<void> _setRole(String role) async {
    await _storage.write(key: 'user_role', value: role);
  }

  Future<String?> loadRole() async {
    _role = await _storage.read(key: 'user_role');
    notifyListeners();
    return _role;
  }

  /// Login with Google and store token
  Future<void> loginWithGoogle(String idToken) async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await _authService.loginWithGoogle(idToken);
      _token = token;
       _role = 'users';
      await _setToken(token);
      await _setRole(_role!);
      notifyListeners();
    } catch (e, stack) {
      throw Exception('Login dengan Google gagal: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login with email and password
Future<void> login(String email, String password) async {
  _isLoading = true;
  notifyListeners();

  try {
    final result = await _authService.login(email, password);

    _token = result['token'];
    _role = result['role'];

    if (_token == null || _role == null) {
      throw Exception('Login gagal: token atau role null.');
    }

    await _setToken(_token!);
    await _setRole(_role!);
    notifyListeners();
  } catch (e) {
    print("❌ AuthProvider login error: $e");
    throw Exception('Login gagal: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  /// Register with name, email, and password
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

  /// Update user password
  Future<bool> updatePassword(
      String currentPassword, String newPassword) async {
    _isLoading = true;
    _successMessage = null;
    _errorMessage = null;
    notifyListeners();

    try {
      final message =
          await _authService.updatePassword(currentPassword, newPassword);
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
      }
      _token = null;
      _role = null;
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_role');
      notifyListeners();
    } catch (e, stack) {
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
      throw Exception('Gagal clear secure storage: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

/* 
  * This file contains the AuthProvider class which manages authentication state
 * and provides methods for login, registration, and logout.
 * It uses ChangeNotifier to notify listeners of changes in authentication state.
 */
class AuthProvider with ChangeNotifier {
  String? _token;
  final AuthService _authService = AuthService();

  String? get token => _token;

  Future<void> login(String email, String password) async {
    _token = await _authService.login(email, password);
    await _saveTokenToStorage(_token!);
    notifyListeners();
  }

  Future<void> register(
      String name, String email, String password, String phone) async {
    await _authService.register(name, email, password, phone);
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> _saveTokenToStorage(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }
}

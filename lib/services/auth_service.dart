import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siappa/configs/api_config.dart';

/// AuthService handles authentication-related operations:
/// login, registration, and logout. Communicates with the backend API.
class AuthService {

  /// Request Headers
  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json'
  };


  /// Login with Google.
  /// [token] is the Google ID token.
  /// Returns backend auth token if successful.
  Future<String> loginWithGoogle(String token) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.google));
    final response = await http.post(
      url,
      headers: _jsonHeaders,
      body: jsonEncode({'id_token': token}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['token'] == null) {
        throw Exception('Login dengan Google gagal: Token tidak ditemukan');
      }
      return data['token'];
    } else {
      String message = 'Login dengan Google gagal';
      try {
        final errorData = jsonDecode(response.body);
        message += ': ${errorData['error'] ?? response.body}';
      } catch (_) {
        message += ': ${response.body}';
      }
      throw Exception(message);
    }
  }

  /// Login with email and password.
  /// Returns backend auth token if successful.
  Future<String> login(String email, String password) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.login));
    final response = await http.post(
      url,
      headers: _jsonHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['token'] == null) {
        throw Exception('Login gagal: Token tidak ditemukan');
      }
      return data['token'];
    } else {
      String message = 'Login gagal';
      try {
        final errorData = jsonDecode(response.body);
        message += ': ${errorData['error'] ?? response.body}';
      } catch (_) {
        message += ': ${response.body}';
      }
      throw Exception(message);
    }
  }

  /// Logout by invalidating token on backend.
  Future<void> logout(String token) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.logout));
    final response = await http.post(
      url,
      headers: {
        ..._jsonHeaders,
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      String message = 'Logout gagal';
      try {
        final errorData = jsonDecode(response.body);
        message += ': ${errorData['error'] ?? response.body}';
      } catch (_) {
        message += ': ${response.body}';
      }
      throw Exception(message);
    }
  }

  /// Register new user.
  Future<void> register(
      String name, String email, String password, String phone) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.register));
    final response = await http.post(
      url,
      headers: _jsonHeaders,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    );

    if (response.statusCode != 201) {
      String message = 'Registrasi gagal';
      try {
        final errorData = jsonDecode(response.body);
        message += ': ${errorData['error'] ?? response.body}';
      } catch (_) {
        message += ': ${response.body}';
      }
      throw Exception(message);
    }
  }
}
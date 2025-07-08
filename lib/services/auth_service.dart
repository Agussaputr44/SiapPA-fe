import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../configs/api_config.dart';

/// AuthService handles authentication-related operations:
/// login, registration, logout, and password updates. Communicates with the backend API.
class AuthService {
  /// Request Headers
  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json'
  };

  final _secureStorage = const FlutterSecureStorage();

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

  /// Register menggunakan email dan password
  Future<String> register(String name, String email, String password) async {
    // Ganti endpoint URL sesuai endpoint register kamu
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.register));
    final response = await http.post(
      url,
      headers: _jsonHeaders,
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      // Ambil pesan dari response
      return data['message'] ?? 'Registrasi berhasil. Silakan cek email Anda.';
    } else {
      String message = 'Registrasi gagal';
      try {
        final errorData = jsonDecode(response.body);
        if (errorData is Map && errorData.containsKey('message')) {
          message += ': ${errorData['message']}';
        } else if (errorData is Map) {
          message += ': ${errorData.values.join(', ')}';
        } else {
          message += ': ${response.body}';
        }
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

  /// Update user password.
  /// [currentPassword] is the current password, [newPassword] is the new password.
  /// Returns success message if successful.
  Future<String> updatePassword(String currentPassword, String newPassword) async {
    try {
      // Validate new password
      if (newPassword.isEmpty || newPassword.length < 8) {
        // Fluttertoast.showToast(
        //   msg: 'Password harus memiliki minimal 8 karakter',
        //   toastLength: Toast.LENGTH_SHORT,
        // );
        throw Exception('Password invalid');
      }

      // Retrieve auth token
      String? token = await _secureStorage.read(key: 'auth_token');
      if (token == null || token.isEmpty) {
        // Fluttertoast.showToast(
        //   msg: 'Pengguna belum terautentikasi',
        //   toastLength: Toast.LENGTH_SHORT,
        // );
        throw Exception('Tidak terautentikasi');
      }

      final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.updatePassword));

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          ..._jsonHeaders,
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Password berhasil diubah';
      } else {
        String message = 'Gagal mengubah password';
        try {
          final errorData = jsonDecode(response.body);
          message += ': ${errorData['error'] ?? response.body}';
        } catch (_) {
          message += ': ${response.body}';
        }
        throw Exception(message);
      }
    } catch (e) {
      print('Error mengubah password: $e');
      // Fluttertoast.showToast(
      //   msg: 'Terjadi kesalahan: $e',
      //   toastLength: Toast.LENGTH_SHORT,
      // );
      rethrow;
    }
  }
}
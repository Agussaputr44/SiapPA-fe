import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siappa/configs/api_config.dart';

/* 
 * This file contains the AuthService class which handles authentication-related operations
 * such as login, registration and logout. It communicates with the backend API to perform these actions.
 */

class AuthService {


  // login with google
  // This method sends a POST request to the backend with the Google ID token
  // and returns the authentication token if successful.
 Future<String> loginWithGoogle(String token) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.google));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_token': token}),
    );

    if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
    } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Login dengan Google gagal: ${errorData['error'] ?? response.body}');
    }
 }

  /// Login method to authenticate user with email and password.
  Future<String> login(String email, String password) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.login));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }

  Future<void> logout(String token) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.logout));
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Logout gagal: ${response.body}');
    }
  }

  Future<void> register(
      String name, String email, String password, String phone) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.register));
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Registrasi gagal: ${response.body}');
    }
  }
}

import 'dart:convert';

import '../configs/api_config.dart';
import 'package:http/http.dart' as http;

class UsersService {
  // Method to fetch user data from the API
  Future<Map<String, dynamic>> fetchUserDetail(String token) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.getUserProfile));
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['user'];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(
          'Gagal memuat data: ${errorData['error'] ?? response.body}');
    }
  }

Future<Map<String, dynamic>> updateProfile(
  String token, {
  String? name,
  String? password,
  String? fotoProfil,
}) async {
  final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.updateUserProfile));
  final body = <String, dynamic>{};

  if (name != null && name.isNotEmpty) {
    body['name'] = name;
  }
  if (password != null && password.isNotEmpty) {
    body['password'] = password;
  }
  if (fotoProfil != null && fotoProfil.isNotEmpty) {
    body['foto_profil'] = fotoProfil;
  }

  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['user'];
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(
      'Gagal update profil: ${errorData['error'] ?? response.body}',
    );
  }
}

  Future<List<dynamic>> fetchAllUsers(String? token) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.getAllUsers));
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']; 
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(
        'Gagal memuat data: ${errorData['error'] ?? response.body}',
      );
    }
  }
}

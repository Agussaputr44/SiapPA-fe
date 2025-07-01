import 'dart:convert';

import '../configs/api_config.dart';
import 'package:http/http.dart' as http;

class UsersService {
  // Method to fetch user data from the API
  Future<Map<String, dynamic>> fetchUserDetail(String token) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.getUserProfile));
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'
      , 'Authorization': 'Bearer $token'},
      
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['user']; 
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(
        'Gagal memuat data: ${errorData['error'] ?? response.body}'
      );
    }
  }
}
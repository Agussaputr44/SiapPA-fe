import 'dart:convert';
import '../configs/api_config.dart';
import 'package:http/http.dart' as http;

class PengaduansService {
  Future<List<dynamic>> fetchAllPengaduans(String token) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.pengaduans));

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Fetched data: ${data['data']}");
      return data['data'];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Gagal memuat data: ${errorData['error'] ?? response.body}');
    }
  }
}

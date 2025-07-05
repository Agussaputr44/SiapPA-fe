import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/api_config.dart';

class ArticlesService {
  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json'
  };
  // method get all artikels with token in request
  Future<List<dynamic>> fetchAllArticles(String token) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.articles));

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return data['data'];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(
          'Gagal memuat data: ${errorData['error'] ?? response.body}');
    }
  }

  Future<String> addArticle(String judul, String isi, String foto) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.articles));
    final response = await http.post(
      url,
      headers: _jsonHeaders,
      body: jsonEncode({'judul': judul, 'isi': isi, 'foto': foto}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      // Ambil pesan dari response
      return data['message'] ?? 'Artikel berhasil ditambahkan.';
    } else {
      String message = 'Artikel gagal ditambahkan';
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
}

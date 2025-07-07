import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/api_config.dart';

class ArticlesService {


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
      return data['data'];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(
          'Gagal memuat data: ${errorData['error'] ?? response.body}');
    }
  }


  Future<String> addArticle(
      String? token, String judul, String isi, String foto) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.articles));
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
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

  Future<String> deleteArticle(String? token, int id) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.artikelDelete(id)));
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Berhasil dihapus';
    } else {
      throw Exception('Gagal menghapus artikel: ${response.reasonPhrase}');
    }
  }


  // New method for updating article
  Future<String> updateArticle(String? token, int id, String judul, String isi, String foto) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.artikelUpdate(id))); 
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'judul': judul,
        'isi': isi,
        'foto': foto
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Artikel berhasil diperbarui.';
    } else {
      String message = 'Artikel gagal diperbarui';
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
